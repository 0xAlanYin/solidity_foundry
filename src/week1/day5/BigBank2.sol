// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "./../day4/Bank2.sol";

contract BigBank is Bank {
    uint256 public constant MIN_DEPOST_AMOUNT = 0.001 ether;

    constructor(address owner) Bank(owner) {}

    modifier mustBeBigDepoist() {
        require(msg.value > MIN_DEPOST_AMOUNT);
        _;
    }

    receive() external payable virtual override mustBeBigDepoist {
        // check
        uint256 amount = msg.value;
        require(amount > 0, "depoist amount must greater than 0");

        // increase balance
        address user = msg.sender;
        balances[user] += amount;

        // update top3 user
        super._updateTop3User(user, balances[user]);

        // send event
        emit Deposited(user, balances[user]);
    }
}
