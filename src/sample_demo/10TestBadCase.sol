// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// 数组的使⽤要特别注意 Gas 问题
contract TestBadCase {
    
    uint[] public numbers;

    function badOne() public {
        // 如果数组的长度特别长，这里非常消耗 Gas
        uint len = numbers.length;
        for (uint256 i = 0; i < len; i++) {
            // do someting
        }
    }

    // 在对于顺序不敏感的场景，可以优化
    function remove(uint index) public {
        uint len = numbers.length;
        if (index == len - 1) {
            numbers.pop();
        } else {
            // 技巧：与最后一个元素交换位置，移除最后一个元素，节省gas
            numbers[index] = numbers[len -1];
            numbers.pop();
        }
    }
}