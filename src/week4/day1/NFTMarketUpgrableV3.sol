// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract NFTMarket is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    IERC20 private s_erc20;
    IERC721 private s_erc721;

    bytes32 private constant STRUCT_HASH =
        keccak256("Permit(address owner,uint256 tokenId,uint256 price,uint256 nonce,uint256 deadline)");

    bytes32 private constant TYPE_HASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    constructor() {
        _disableInitializers();
    }

    function initialize(address initializOwner_, address erc20Token_, address erc721Token_) public initializer {
        __Ownable_init(initializOwner_);

        __UUPSUpgradeable_init();

        s_erc20 = IERC20(erc20Token_);
        s_erc721 = IERC721(erc721Token_);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function listWithPermit(
        address owner,
        uint256 tokenId,
        uint256 price,
        uint256 nonce,
        uint256 deadline,
        bytes memory signature
    ) external {
        bytes32 digest = _caculteTypeDataHash(owner, tokenId, price, nonce, deadline);
        address signer = ECDSA.recover(digest, signature);
        require(signer == owner, "signer is invalid");

        // do list operate
    }

    function _caculteTypeDataHash(address owner, uint256 tokenId, uint256 price, uint256 nonce, uint256 deadline)
        internal
        returns (bytes32)
    {
        return MessageHashUtils.toTypedDataHash(
            _buildDomainSeparator(), _caculteStuctHash(owner, tokenId, price, nonce, deadline)
        );
    }

    function _buildDomainSeparator() internal returns (bytes32) {
        return keccak256(
            abi.encode(TYPE_HASH, keccak256(bytes("NFTMarket")), keccak256(bytes("1")), block.chainid, address(this))
        );
    }

    function _caculteStuctHash(address owner, uint256 tokenId, uint256 price, uint256 nonce, uint256 deadline)
        internal
        returns (bytes32)
    {
        return keccak256(abi.encode(STRUCT_HASH, owner, tokenId, price, nonce, deadline));
    }
}
