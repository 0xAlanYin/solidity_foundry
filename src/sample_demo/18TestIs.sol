// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// 继承
// • 使⽤关键字 is
// • 继承时，链上实际只有⼀个合约被创建，基类合约的代码会被编译进派⽣合约。
// • 派⽣合约可以访问基类合约内的所有⾮私有（private）成员，因此内部（internal）函数和状态变量在派⽣合约⾥是可以直接使⽤的
contract Parent {
    uint256 public a;

    constructor() {
        a = 1;
    }
}

contract Sub is Parent {
    uint256 public b;

    constructor() {
        b = 2;
    }
}
