// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestArray {
    // 固定长度的数组
    uint[4] fours;
    // 动态数组
    uint[] public numbers;

    function copy(uint[] calldata arrs) public returns (uint len) {
        numbers = arrs;
        return numbers.length;
    }

    function name(uint len) public pure {
        string[4] memory strArr = ["this", "is", "string", "array"];
        // uint[4] memory intArr = new uint[](len);
    }

    function addElement(uint x) public {
        numbers.push(x);
        numbers.pop();
    }
}