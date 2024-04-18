// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestAvaiable {
    uint public data;
    constructor(){
    }

    function setData(uint x) internal {
        data = x;
    }

    function cal(uint a) public pure returns (uint) {
        return a + 1;
    }
 
}
