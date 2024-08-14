// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.24 and less than 0.9.0
pragma solidity ^0.8.24;

contract Function {
    function someFuncWithManyInputs(uint256 x, uint256 y, uint256 z, address a, bool b, string memory c)
        public
        pure
        returns (uint256)
    {}

    function callFuncWithKeyValue() external pure returns (uint256) {
        return someFuncWithManyInputs({x: 1, y: 2, z: 3, a: address(0), b: true, c: "c"});
    }

    function callFunc() external pure returns (uint256) {
        return someFuncWithManyInputs(1, 2, 3, address(0), true, "d");
    }
}
