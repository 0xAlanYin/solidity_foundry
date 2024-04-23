// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

// 扩展挑战Token 购买 NFT 合约，能够使用ERC20扩展中的回调函数来购买某个 NFT ID。
contract TokenBankV3 is ITokenReceiver {

    address public token;

    address public myNFTMarket;

    constructor(address _token, address _myNFTMarket) {
        token = _token;
        myNFTMarket = _myNFTMarket;
    }

    // tokensReceived 回调实现
    function tokenReceived(
        address recipient,
        uint256 tokenId
    ) external returns (bool) {
        require(msg.sender == token, "no permission");
        (bool success, ) = myNFTMarket.call(
            abi.encodeWithSignature("buyNFT(uint256)", tokenId)
        );
        return success;
    }
}
