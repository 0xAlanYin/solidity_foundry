// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "./MyToken.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenBank {
    event TokenBank_deposit(address indexed sender, uint256 amount);
    event TokenBank_withdraw(address indexed sender, uint256 amount);

    mapping(address => uint256) deposits;

    IERC20 public erc20;

    constructor(address tokenAddress) {
        erc20 = IERC20(tokenAddress);
    }

    function deposit(uint256 amount) public {
        require(amount > 0, "amount must greater than 0");

        address owner = msg.sender;
        deposits[owner] += amount;
        SafeERC20.safeTransferFrom(erc20, owner, address(this), amount);

        emit TokenBank_deposit(owner, amount);
    }

    function withdraw(uint256 amount) public {
        address owner = msg.sender;
        require(amount <= deposits[owner], "amount must less than or equal to deposit amount");

        deposits[owner] -= amount;
        SafeERC20.safeTransfer(erc20, owner, amount);

        emit TokenBank_withdraw(owner, amount);
    }

    function balanceOf(address user) public view returns (uint256) {
        return deposits[user];
    }
}
