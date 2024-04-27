// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract TestInt {
    // uint256 max = type(uint256).max;

    function getMinAndMax() public pure returns (uint256, uint256) {
        uint256 min = type(uint256).min;
        uint256 max = type(uint256).max;
        return (min, max);
    }
}
