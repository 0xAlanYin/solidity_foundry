// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract StorageDemo {
    // 以下存储在 storage 中
    uint256 number;
    bool isSuccess;
    // storage 中存储类似于引用美，而不是数组本身
    uint256[] myArr;
    mapping(address => uint256) mappings;
    uint256 favoriteNumber; // Stored at slot 0
    bool someBool; // Stored at slot 1
    uint256[] myArray; /* Array Length Stored at slot 2,
        but the objects will be the keccak256(2), since 2 is the storage slot of the array */
    mapping(uint256 => bool) myMap; /* An empty slot is held at slot 3
        and the elements will be stored at keccak256(h(k) . p)
        p: The storage slot (aka, 3)
        k: The key in hex
        h: Some function based on the type. For uint256, it just pads the hex
        */

    constructor() {
        favoriteNumber = 25; // See stored spot above // SSTORE
        someBool = true; // See stored spot above // SSTORE
        myArray.push(222); // SSTORE
        myMap[0] = true; // SSTORE
        i_not_in_storage = 123;
    }

    // 以下不存储在 storage 中
    // 编译后会直接替换成对应的值
    uint256 constant NOT_IN_STORAGE = 123;
    uint256 immutable i_not_in_storage;

    function doStuff() public {
        uint256 newVar = favoriteNumber + 1; // SLOAD
        bool otherVar = someBool; // SLOAD
            // ^^ memory variables
    }
}
