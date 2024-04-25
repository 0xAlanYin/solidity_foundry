// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

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
    function tokenReceived(address recipient, uint256 amount, bytes memory extraData) external returns (bool) {
        // 只有合约才能调用
        require(msg.sender == token, "no permission");
        deposits[recipient] += amount;
        return true;
    }

    function balanceOf(address user) public view returns (uint256) {
        return deposits[user];
    }
}
