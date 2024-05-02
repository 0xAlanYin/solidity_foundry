// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;
    address public owner;

    event Counter_SetNumbet(uint256 number);

    function setNumber(uint256 newValue) public {
        number = newValue;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}
