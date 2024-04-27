// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract Counter {
    uint256 public count;
    address public add;

    function getCount() public {
        count = count + 1;
        add = msg.sender;
    }
}

contract MyContract {
    function call1() public {
        Counter c = new Counter();
        c.getCount();
    }

    function call2(Counter c) public {
        c.getCount();
    }
}

// 创建合约可使⽤New 关键字()
// • 每个合约都是⼀个类型，可声明⼀个合约类型。
// 如：Counter c; 则可以使⽤c.count() 调⽤函数
// • 合约可以显式转换为address类型，从⽽可以使⽤地址类型的成员函数。 address(this)
