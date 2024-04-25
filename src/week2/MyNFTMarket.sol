// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./MyToken.sol";
import "./MyERC721.sol";

contract MyNFTMarket {
    // 记录 tokenId 对应的售价
    mapping(uint256 => uint256) public tokenId2Price;

    // 记录 tokenId 对应的卖家
    mapping(uint256 => address) public tokenId2Seller;

    address public erc20Token;

    address public erc721Token;

    constructor(address _erc20Token, address _erc721Token) {
        erc20Token = _erc20Token;
        erc721Token = _erc721Token;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    // list: 实现上架功能，NFT 持有者可以设定一个价格（需要多少个 Token 购买该 NFT）并上架 NFT 到 NFT 市场
    function list(uint256 tokenId, uint256 price) public {
        require(IERC721(erc721Token).ownerOf(tokenId) == msg.sender, "not owner");
        tokenId2Price[tokenId] = price;
        tokenId2Seller[tokenId] = msg.sender;
    }

    // approve before
    // buyNFT：实现购买 NFT 功能，用户转入所定价的 token 数量，获得对应的 NFT
    function buyNFT(uint256 tokenId) public {
        // 转移token: 买方给市场授权
        IERC20(erc20Token).transferFrom(msg.sender, tokenId2Seller[tokenId], tokenId2Price[tokenId]);

        // 转移nft: 卖方给市场授权
        IERC721(erc721Token).safeTransferFrom(tokenId2Seller[tokenId], msg.sender, tokenId);
    }

    // tokensReceived 回调实现
    function tokenReceived(address buyer, uint256 amount, bytes memory data) external returns (bool) {
        uint256 tokenId = abi.decode(data, (uint256));
        IERC20(erc20Token).transfer(tokenId2Seller[tokenId], tokenId2Price[tokenId]);

        IERC721(erc721Token).safeTransferFrom(tokenId2Seller[tokenId], buyer, tokenId);
        return true;
    }
}
