// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

// 200274
// 150503
contract BadGas {
    
    uint256 public miniumUsd = 20* 1e18;

    address public owner;

    constructor() {
        owner = msg.sender;
    }
}