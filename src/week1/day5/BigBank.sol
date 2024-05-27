// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {Bank} from "../day4/Bank.sol";

interface IBigBank {
    function withdraw(uint256 amount) external;
}

contract Ownable {}

// 用 Solidity 编写 BigBank 智能合约
contract BigBank is Bank {
    // min deposit amount is 0.001 ether
    uint256 public minDepositAmount = 0.001 ether;

    constructor(address _newOwner) Bank(_newOwner) {}

    // 存款金额 >0.001 ether
    modifier validMinDeposit() {
        require(msg.value > minDepositAmount, "min deposit must great than 0.001 ether");
        _;
    }

    receive() external payable virtual override validMinDeposit {
        balances[msg.sender] += msg.value;
        super.updateTop3User(msg.sender);
        emit Bank_deposit(msg.sender, msg.value);
    }
}
