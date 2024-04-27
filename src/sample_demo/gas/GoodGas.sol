// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

error NotOwner();

contract GoodGas {
    // 如果变量值不变，使用 constant 节约 gas
    // 174139 gas no-constant
    // 150503 gas constant
    uint256 public constant miniumUsd = 20 * 1e18;

    // 200274 gas  no-immutable
    // 150503 gas immutable
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // 174139 gas
        // require(msg.sender == owner, "Sender is not owner");
        // 174125 gas 相比 require 更节省 gas
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }
}
