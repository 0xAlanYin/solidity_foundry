// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract TestInt {

    // uint256 max = type(uint256).max;

    function getMinAndMax() public pure returns (uint, uint) {
        uint min = type(uint).min;
        uint max = type(uint).max;
        return (min, max); 
    }
}
