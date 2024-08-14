// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.24 and less than 0.9.0
pragma solidity ^0.8.24;

contract PrimitivesDataType {
    mapping(address => uint256) map;

    uint256[] public arr;

    function remove(address key) public {
        delete map[key];
    }

    function deleteElement(uint256 index) public {
        delete arr[index];
        uint256[] memory arr2 = arr;
    }

    function removeIndex(uint256 index) external {
        uint256 length = arr.length;
        require(index < length, "out of bound");

        if (index != length - 1) {
            arr[index] = arr[length - 1];
        }
        arr.pop();
    }
}
