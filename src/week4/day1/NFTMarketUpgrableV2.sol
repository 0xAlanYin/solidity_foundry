pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/// @custom:oz-upgrades-from src/week4/day1/NFTMarketUpgrable.sol:NFTMarket
contract NFTMarketV2 is IERC721Receiver, Initializable, UUPSUpgradeable, OwnableUpgradeable {
    mapping(uint256 => uint256) public tokenIdPrice;
    mapping(uint256 => address) public tokenSeller;
    address public token;
    address public nftToken;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        // 确保初始化方法只运行一次，以防止意外重新初始化
        _disableInitializers();
    }

    function initialize(address initialOwner_, address token_, address nftToken_) public initializer {
        // 开启了增强的授权机制和
        __Ownable_init(initialOwner_);
        // 开启可升级功能
        __UUPSUpgradeable_init();

        // 初始化 erc20 和 erc721
        token = token_;
        nftToken = nftToken_;
    }

    // 确保了安全的合约升级，只允许所有者授权新的合约版本
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    // approve(address to, uint256 tokenId) first
    function list(uint256 tokenId, uint256 amount) public {
        IERC721(nftToken).safeTransferFrom(msg.sender, address(this), tokenId, "");
        tokenIdPrice[tokenId] = amount;
        tokenSeller[tokenId] = msg.sender;
    }

    function buy(uint256 tokenId, uint256 amount) external {
        require(amount >= tokenIdPrice[tokenId], "low price");

        require(IERC721(nftToken).ownerOf(tokenId) == address(this), "aleady selled");

        IERC20(token).transferFrom(msg.sender, tokenSeller[tokenId], tokenIdPrice[tokenId]);
        IERC721(nftToken).transferFrom(address(this), msg.sender, tokenId);
    }

    // 加⼊离线签名上架 NFT 功能⽅法（签名内容：tokenId， 价格），实现⽤户⼀次性使用 setApproveAll 给 NFT 市场合约，每个 NFT 上架时仅需使⽤签名上架。
    function listWithPermit(bytes memory message, bytes memory signature, uint256 tokenId, uint256 amount) public {
        // TODO
        // 先验证签名是 msg.sender
        bytes32 hash = MessageHashUtils.toEthSignedMessageHash(message);
        address signer = ECDSA.recover(hash, signature);
        require(msg.sender == signer, "invalid signature");

        // setApprovalForAll 给 NFTMarket
        IERC721(nftToken).setApprovalForAll(address(this), true);

        // 上架 NFT
        list(tokenId, amount);
    }

    function version() public pure returns (uint256) {
        return 2;
    }
}