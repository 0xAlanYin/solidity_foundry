// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract Counter {
    uint256 public number;
    address public owner;

    event NumberChange(uint256 newValue);

    function setNumber(uint256 newValue) public {
        number = newValue;
    }
}