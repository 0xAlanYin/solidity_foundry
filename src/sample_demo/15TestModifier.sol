// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// ⾃定义修饰符 - 函数修改器
// ⽤修改器修饰⼀个函数， ⽤来添加函数的⾏为，如检查输⼊条件、控制访问、重⼊控制
contract TestModifier {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    // ⽤ modifier 定义⼀个修改器
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call this");
        // 函数修改器修饰函数时，函数体被插⼊到 “_;”
        _;
    }

    function withdraw(uint amount) public onlyOwner {
        payable(owner).transfer(amount);
    }
}
