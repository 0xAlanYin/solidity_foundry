// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestInt {
    function getMinAndMax() public pure returns (uint, uint) {
        uint min = type(uint).min;
        uint max = type(uint).max;
        return (min, max);
    }
}
