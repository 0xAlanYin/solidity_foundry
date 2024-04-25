// SPDX-License-Identifier: UNLICENSE
pragma solidity 0.8.25;

contract TestOverflow {
    function add1() public pure returns (uint8) {
        uint8 x = 128;
        uint8 y = x * 2;
        return y;
    }

    function add2() pure public returns (uint8) {
        uint8 x = 250;
        uint8 y =  6;
        return x + y;
    }
}
