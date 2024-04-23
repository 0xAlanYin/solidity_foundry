// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract TokenBank is ITokenReceiver {
    mapping(address => uint256) deposits;

    address public token;

    constructor(address addr) {
        token = addr;
    }

    function deposit(uint256 amount) public {
        MyToken(token).transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
    }

    function withdraw(uint256 amount) public {
        MyToken(token).transfer(msg.sender, amount);
        deposits[msg.sender] -= amount;
    }

    // tokensReceived 回调实现
    function tokenReceived(address recipient, uint256 amount) external returns (bool) {
        require(msg.sender == recipient, "no permission");
        deposits[msg.sender] += amount;
        return true;
    }
}
