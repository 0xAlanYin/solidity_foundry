// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";

contract MyNFTMarket {
    // 记录 tokenId 对应的售价
    mapping(uint256 => uint256) public tokenId2Price;

    // 记录 tokenId 对应的卖家
    mapping(uint256 => address) public tokenId2Seller;

    address public eip2612Token;

    address public erc721Token;

    // 白名单
    mapping(uint256 => mapping(address => bool)) whitelist;

    constructor(address _eip2612Token, address _erc721Token) {
        eip2612Token = _eip2612Token;
        erc721Token = _erc721Token;
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
        IERC20(eip2612Token).transferFrom(msg.sender, tokenId2Seller[tokenId], tokenId2Price[tokenId]);

        // 转移nft: 卖方给市场授权
        IERC721(erc721Token).safeTransferFrom(tokenId2Seller[tokenId], msg.sender, tokenId);
    }

    error NotSeller(string msg);

    // 添加白名单地址，只有白名单地址可以购买
    function addWhitelist(uint256 tokenId, address _whitelist) public {
        // 检查 msg.sender 是否存在 tokenId2Seller 中
        if (tokenId2Seller[tokenId] != msg.sender) {
            revert NotSeller("not seller, can not add whitelist");
        }
        whitelist[tokenId][_whitelist] = true;
    }

    // 只有离线授权的白名单地址才可以购买 NFT
    function permitBuy(uint256 tokenId, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
        if (!whitelist[tokenId][msg.sender]) {
            revert("not in whitelist, can not buy");
        }

        IERC20Permit(eip2612Token).permit(msg.sender, address(this), tokenId2Price[tokenId], deadline, v, r, s);
        buyNFT(tokenId);
    }
}
