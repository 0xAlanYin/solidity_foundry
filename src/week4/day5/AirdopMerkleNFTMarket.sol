// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// 实现一个 AirdopMerkleNFTMarket 合约(假定 Token、NFT、AirdopMerkleNFTMarket 都是同一个开发者开发)，功能如下：
// 1.基于 Merkel 树验证某用户是否在白名单中
// 2.在白名单中的用户可以使用上架（和之前的上架逻辑一致）指定价格的优惠 50% 的Token 来购买 NFT， Token 需支持 permit 授权。
// 要求使用 multicall( delegateCall 方式) 一次性调用两个方法：
// 1.permitPrePay() : 调用token的 permit 进行授权
// 2.claimNFT() : 通过默克尔树验证白名单，并利用 permitPrePay 的授权，转入 token 转出 NFT
contract AirdopMerkleNFTMarket is IERC721Receiver {
    event AirdopMerkleNFTMarket_Claimed(address indexed user);

    // Merkel 树根
    bytes32 public merkleRoot;
    // Token 合约地址
    address public token;
    // NFT 合约地址
    address public nft;
    // 记录 tokenId 对应的售价
    mapping(uint256 => uint256) public tokenId2Price;
    // 记录 tokenId 对应的卖家
    mapping(uint256 => address) public tokenId2Seller;

    // 构造函数
    constructor(bytes32 _merkleRoot, address _token, address _nft) {
        merkleRoot = _merkleRoot;
        token = _token;
        nft = _nft;
    }

    // 实现 permitPrePay
    function permitPrePay(
        address owner,
        address spender,
        uint256 tokenId,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        // 验证价格是否足够
        require(amount >= tokenId2Price[tokenId] / 2, "low price");
        // 验证 nft 没有卖出
        require(IERC721(nft).ownerOf(tokenId) == address(this), "aleady selled");

        // 授权
        IERC20Permit(token).permit(owner, spender, tokenId, deadline, v, r, s);

        // 转移 token
        IERC20(token).transfer(tokenId2Seller[tokenId], tokenId2Price[tokenId] / 2);

        // 转移 nft
        IERC721(nft).transferFrom(address(this), msg.sender, tokenId);
    }

    // 实现 claimNFT
    function claimNFT(bytes32[] calldata merkleProof) external returns (bool) {
        // 1.验证用户是否在白名单中
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

        require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "AirdopMerkleNFTMarket: Invalid proof");

        emit AirdopMerkleNFTMarket_Claimed(msg.sender);
        return true;
    }

    // list: 实现上架功能，NFT 持有者可以设定一个价格（需要多少个 Token 购买该 NFT）并上架 NFT 到 NFT 市场
    function list(uint256 tokenId, uint256 price) public {
        IERC721(nft).safeTransferFrom(msg.sender, address(this), tokenId, "");
        tokenId2Price[tokenId] = price;
        tokenId2Seller[tokenId] = msg.sender;
    }

    // 实现 multicall
    function multicall(bytes[] calldata data) external virtual returns (bytes[] memory) {
        bytes[] memory results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            results[i] = result;
            require(success, "AirdopMerkleNFTMarket: multicall failed");
        }
        return results;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }
}
