// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract Bank is Ownable {
    event Bank_Withdraw(address indexed owner, uint256 amount);
    event Bank_Deposit(address indexed user, uint256 amount);

    mapping(address => uint256) public balances;

    constructor(address owner_) Ownable(owner_) {}

    function deposit() public payable {
        uint256 amount = msg.value;
        require(amount > 0, "Bank: msg.value should be greater than 0");

        address user = msg.sender;
        balances[user] += amount;

        emit Bank_Deposit(user, amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Bank: amount should be greater than 0");
        require(amount <= address(this).balance, "Bank: amount should be less than balance");

        Address.sendValue(payable(msg.sender), amount);

        emit Bank_Withdraw(msg.sender, amount);
    }
}
