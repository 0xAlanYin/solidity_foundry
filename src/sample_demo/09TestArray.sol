// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestArray {
    // 固定长度的数组
    uint[4] fours= [1,2,3,4];
    // 动态数组
    uint[] public numbers;

    // 作为参数，使用 calldata 
    function copy(uint[] calldata arr) public returns (uint len) {
        numbers = arr;
        return numbers.length;
    }

    // 作为参数，使用 memory 
    function handle(uint[] memory arr) internal {
        
    }

    function name() public pure returns (string[4] memory arr){
        string[4] memory strArr = ["this", "is", "string", "array"];
        // uint[4] memory intArr = new uint[](len);
        return strArr;
    }

    function addElement(uint x) public {
        numbers.push(x);
        numbers.pop();
    }

}