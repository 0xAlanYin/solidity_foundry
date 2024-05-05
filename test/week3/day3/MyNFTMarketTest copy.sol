// // SPDX-License-Identifier: UNLICENSED
// pragma solidity 0.8.25;

// import {Test, console} from "forge-std/Test.sol";

// import {MyERC20Permit} from "../../../src/week3/day3/MyERC20Permit.sol";
// import {MyNFTMarket} from "../../../src/week3/day3/MyNFTMarket.sol";
// import {MyERC721} from "../../../src/week2/MyERC721.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
// import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
// import "./SignatureUtil.sol";

// contract MyERC20PermitTest is Test {
//     MyNFTMarket market;
//     MyERC20Permit public erc20Permit;
//     MyERC721 public erc721;

//     address public bob = address(1);
//     address public cindy = address(2);

//     function setUp() public {
//         erc20Permit = new MyERC20Permit();
//         erc721 = new MyERC721();
//         market = new MyNFTMarket(address(erc20Permit), address(erc721));
//         erc721.mint(bob, "0xMockIPFSLink");
//     }

//     // test permitBuy
//     function test_permitBuy() public {
//         // 先添加白名单
//         // 再上架
//         //再permitBuy
//         //再检查是否转移成功
//          // bob 上架
//         uint256 tokenId = 1;
//         _list(tokenId, bob, myNFTMarket);


//         uint256 permitAmount = 1e18;
//         SignatureUtil.Permit memory permit = SignatureUtil.Permit({
//             owner: owner,
//             spender: spender,
//             value: permitAmount,
//             nonce: 0,
//             deadline: block.timestamp + 1 days
//         });

//         bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
//         (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

//         // cindy 授权后成功购买
//         erc20Permit.transfer(cindy, 1000);
//         vm.startPrank(cindy);
//         erc20Permit.approve(address(myNFTMarket), 1000);


        
        
//         market.permitBuy(bob, spender, tokenId, deadline, v, r, s);
//         // .permitBuy(tokenId, 100);
//         assertEq(myERC721.ownerOf(tokenId), cindy, "owner is not cindy");
//         vm.stopPrank();
//     }


//      function _list(uint256 tokenId, address seller, MyNFTMarket _myNFTMarket) internal {
//         uint256 tokenId = 1;
//         erc20Permit.transfer(seller, 1000);

//         vm.startPrank(seller);
//         erc721.isApprovedForAll(seller, address(_myNFTMarket));
//         erc721.approve(address(_myNFTMarket), tokenId);

//         _myNFTMarket.list(1, 100);

//         vm.stopPrank();
//     }
// }
