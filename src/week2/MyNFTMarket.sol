// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./MyToken.sol";
import "./MyERC721.sol";

contract MyNFTMarket {
    event MyNFTMarket_List(address indexed seller, uint256 indexed tokenId, uint256 price);
    event MyNFTMarket_NFT_buy(address indexed buyer, uint256 indexed tokenId, uint256 price);

    // 记录 tokenId 对应的售价
    mapping(uint256 => uint256) public tokenId2Price;

    // 记录 tokenId 对应的卖家
    mapping(uint256 => address) public tokenId2Seller;

    IERC20 public erc20Token;

    IERC721 public erc721Token;

    constructor(address _erc20Token, address _erc721Token) {
        erc20Token = IERC20(_erc20Token);
        erc721Token = IERC721(_erc721Token);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        pure
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    // list: 实现上架功能，NFT 持有者可以设定一个价格（需要多少个 Token 购买该 NFT）并上架 NFT 到 NFT 市场
    function list(uint256 tokenId, uint256 price) public {
        address seller = msg.sender;
        require(IERC721(erc721Token).ownerOf(tokenId) == seller, "not owner");

        tokenId2Price[tokenId] = price;
        tokenId2Seller[tokenId] = seller;

        emit MyNFTMarket_List(seller, tokenId, price);
    }

    // approve before
    // buyNFT：实现购买 NFT 功能，用户转入所定价的 token 数量，获得对应的 NFT
    function buyNFT(uint256 tokenId) public {
        // 转移token: 买方给市场授权
        erc20Token.transferFrom(msg.sender, tokenId2Seller[tokenId], tokenId2Price[tokenId]);

        // 转移nft: 卖方给市场授权
        erc721Token.safeTransferFrom(tokenId2Seller[tokenId], msg.sender, tokenId);
    }

    function listV2(uint256 tokenId, uint256 price) public {
        address seller = msg.sender;
        require(erc721Token.ownerOf(tokenId) == seller, "not owner");
        // need approve first
        erc721Token.safeTransferFrom(seller, address(this), tokenId);

        tokenId2Price[tokenId] = price;
        tokenId2Seller[tokenId] = seller;

        emit MyNFTMarket_List(seller, tokenId, price);
    }

    function buyNFTV2(uint256 tokenId) public {
        address buyer = msg.sender;
        erc20Token.transferFrom(buyer, tokenId2Seller[tokenId], tokenId2Price[tokenId]);

        // 转移nft
        erc721Token.safeTransferFrom(address(this), buyer, tokenId);

        emit MyNFTMarket_NFT_buy(buyer, tokenId, tokenId2Price[tokenId]);
    }

    // tokensReceived 回调实现
    function tokenReceived(address buyer, uint256 amount, bytes memory data) external returns (bool) {
        uint256 tokenId = abi.decode(data, (uint256));
        erc20Token.transfer(tokenId2Seller[tokenId], tokenId2Price[tokenId]);

        erc721Token.safeTransferFrom(tokenId2Seller[tokenId], buyer, tokenId);
        return true;
    }
}
