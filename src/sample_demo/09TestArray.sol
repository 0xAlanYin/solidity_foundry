// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract TestArray {
    // 固定长度的数组
    uint256[4] fours = [1, 2, 3, 4];
    // 动态数组
    uint256[] public numbers;

    // 作为参数，使用 calldata
    function copy(uint256[] calldata arr) public returns (uint256 len) {
        numbers = arr;
        return numbers.length;
    }

    // 作为参数，使用 memory
    function handle(uint256[] memory arr) internal {}

    function name() public pure returns (string[4] memory arr) {
        string[4] memory strArr = ["this", "is", "string", "array"];
        // uint[] memory intArr = new uint[](4);
        // uint[] memory arr  = new uint[](1);
        return strArr;
    }

    function addElement(uint256 x) public {
        numbers.push(x);
        numbers.pop();
    }

    function getArr() external view returns (uint256[] memory) {
        return numbers;
    }
}
