// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {ERC20Token} from "../../../src/week4/day5/ERC20Token.sol";
import {NFT} from "../../../src/week4/day5/NFT.sol";
import {AirdopMerkleNFTMarket} from "../../../src/week4/day5/AirdopMerkleNFTMarket.sol";
import {SignatureHelper} from "./SignatureHelper.sol";

contract AirdopMerkleNFTMarketTest is Test {
    // Merkel 树根
    bytes32 merkleRoot;
    // Token 合约地址
    ERC20Token token;
    // NFT 合约地址
    NFT nft;
    // 空投市场
    AirdopMerkleNFTMarket airdopMerkleNFTMarket;
    // 合法的用户
    address validUser = address(0xa8532aAa27E9f7c3a96d754674c99F1E2f824800);

    address owner;
    address spender;
    uint256 ownerPrivateKey = 111;
    SignatureHelper signatureHelper;
    address nftMaker = address(1);

    function setUp() public {
        //proof:0x72155ab19f64defdca605292f85d05e62580c41852b1bff9f02bd9cf4c4ac1ee,0x66af34d373b909013012f47c2e8fcf962ed49c30d72ed525b8867e5fb5f9acbd
        merkleRoot = 0x64767c6bd9dce402a905bfdb430feb7d9f40eacb4722e23aa1ed58f9e759097f; // 使用 js 生成的 Merkel 树根
        token = new ERC20Token();
        token.mint(address(this), 10 ether);
        nft = new NFT();
        airdopMerkleNFTMarket = new AirdopMerkleNFTMarket(merkleRoot, address(token), address(nft));

        signatureHelper = new SignatureHelper(token.DOMAIN_SEPARATOR());

        spender = address(airdopMerkleNFTMarket); // 特别注意！这里 IERC20Permit 的 spender 是 airdopMerkleNFTMarket

        // 给 spender 转 1 ether 用于后续测试
        token.transfer(spender, 1 ether);

        // 指定 owner 的私钥
        owner = vm.addr(ownerPrivateKey);
    }

    // test claimNFT
    function test_claimNFT_success() public {
        // proof:0x72155ab19f64defdca605292f85d05e62580c41852b1bff9f02bd9cf4c4ac1ee,0x66af34d373b909013012f47c2e8fcf962ed49c30d72ed525b8867e5fb5f9acbd
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x72155ab19f64defdca605292f85d05e62580c41852b1bff9f02bd9cf4c4ac1ee;
        proof[1] = 0x66af34d373b909013012f47c2e8fcf962ed49c30d72ed525b8867e5fb5f9acbd;

        vm.startPrank(validUser);
        bool verifySuccess = airdopMerkleNFTMarket.claimNFT(proof);
        assertTrue(verifySuccess, "verify failed");
        vm.stopPrank();
    }

    // test claimNFT failed
    function test_claimNFT_failed() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x72155ab19f64defdca605292f85d05e62580c41852b1bff9f02bd9cf4c4ac1ee;
        proof[1] = 0x72155ab19f64defdca605292f85d05e62580c41852b1bff9f02bd9cf4c4ac1aa; // 无效的 proof
        vm.expectRevert("AirdopMerkleNFTMarket: Invalid proof");
        airdopMerkleNFTMarket.claimNFT(proof);
    }

    // test permitPrePay
    function test_permitPrePay() public {
        uint256 tokenId = 0;
        // owner mint nft 并授权给市场
        vm.startPrank(nftMaker);
        nft.mint(nftMaker, "ipfs://QmfNJZ6SrjeTnbp");
        nft.approve(address(airdopMerkleNFTMarket), tokenId);

        // owner 上架
        uint256 price = 1000;
        airdopMerkleNFTMarket.list(tokenId, price);
        vm.stopPrank();

        // 离线签名
        uint256 nonce = 0;
        uint256 deadline = block.timestamp + 1 days;
        SignatureHelper.Permit memory permit =
            SignatureHelper.Permit(owner, address(airdopMerkleNFTMarket), tokenId, nonce, deadline);
        bytes32 digest = signatureHelper.getTypeData(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        // spener 购买
        vm.startPrank(owner);
        uint256 amount = 500;
        airdopMerkleNFTMarket.permitPrePay(owner, spender, permit.value, amount, deadline, v, r, s);
        vm.stopPrank();
    }

    // test multicall
    function test_multicall() public {
        uint256 tokenId = 0;
        // owner mint nft 并授权给市场
        vm.startPrank(nftMaker);
        nft.mint(nftMaker, "ipfs://QmfNJZ6SrjeTnbp");
        nft.approve(address(airdopMerkleNFTMarket), tokenId);

        // owner 上架
        uint256 price = 1000;
        airdopMerkleNFTMarket.list(tokenId, price);
        vm.stopPrank();

        // 离线签名
        uint256 nonce = 0;
        uint256 deadline = block.timestamp + 1 days;
        SignatureHelper.Permit memory permit =
            SignatureHelper.Permit(owner, address(airdopMerkleNFTMarket), tokenId, nonce, deadline);
        bytes32 digest = signatureHelper.getTypeData(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        // 购买
        vm.startPrank(owner);
        // proof:0x72155ab19f64defdca605292f85d05e62580c41852b1bff9f02bd9cf4c4ac1ee,0x66af34d373b909013012f47c2e8fcf962ed49c30d72ed525b8867e5fb5f9acbd
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x72155ab19f64defdca605292f85d05e62580c41852b1bff9f02bd9cf4c4ac1ee;
        proof[1] = 0x66af34d373b909013012f47c2e8fcf962ed49c30d72ed525b8867e5fb5f9acbd;
        vm.stopPrank();

        vm.startPrank(validUser);
        // 将 bytes32[] memory proof 转为 bytes[] calldata data 中的第一个元素
        bytes memory data = abi.encodeWithSelector(airdopMerkleNFTMarket.claimNFT.selector, proof);
        bytes[] memory datas = new bytes[](1);
        datas[0] = data;
        airdopMerkleNFTMarket.multicall(datas);
        vm.stopPrank();
    }
}
