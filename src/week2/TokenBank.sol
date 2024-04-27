// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "./BaseERC20.sol";

contract TokenBank {
    mapping(address => uint256) deposits;

    BaseERC20 public erc20;

    constructor(address tokenAddress) {
        erc20 = BaseERC20(tokenAddress);
    }

    function deposit(uint256 amount) public payable {
        address owner = msg.sender;
        erc20.transferFrom(owner, address(this), amount);
        deposits[owner] += amount;
    }

    function withdraw(uint256 amount) public {
        address owner = msg.sender;
        erc20.transfer(owner, amount);
        deposits[owner] -= amount;
    }

    function balanceOf(address user) public view returns (uint256) {
        return deposits[user];
    }
}
