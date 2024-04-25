// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// ⾃定义修饰符 - 函数修改器
// ⽤修改器修饰⼀个函数， ⽤来添加函数的⾏为，如检查输⼊条件、控制访问、重⼊控制
contract TestModifier {
    address public owner;

    constructor() {
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

contract TestModifier2 {
    
    // 修改器可以接收参数
    modifier over22(uint8 age) {
        require(age >= 22, "only gt 22 can marray");
        _;
    }

    function marry(uint8 age) public over22(age) {
        // do something
    }
}


contract modifysample {
    uint a = 10;

    modifier mf1 (uint b) {
        uint c = b;
        _;
        c = a;
        a = 11;
    }

     modifier mf2 () {
        uint c = a;
        _;
    }

    modifier mf3() {
        a = 12;
        return ;
        _;
        a = 13;
    }

    function test1() mf1(a) mf2 mf3 public   {
        a = 1;
    }

    function get_a() public view returns (uint)   {
        return a;
    }
}
