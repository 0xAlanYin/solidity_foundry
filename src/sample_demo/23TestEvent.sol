// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Event 事件
// • 合约与外部世界的重要接⼝，通知外部世界链上状态的变化
// • 事件有时也作为便宜的存储
// • 使⽤关键字 event 定义事件，事件不需要实现
// • 使⽤关键字 emit 触发事件
// • 事件中使⽤indexed修饰，表示对这个字段建⽴索引，⽅便外部对该字段过滤查找
contract TestEvent {

    mapping(address => uint) balances;

    event Deposit(address indexed addr,uint amount);

    function deposit(uint amount) public {
        balances[msg.sender] +=  amount;
        
        emit Deposit(msg.sender, amount);
    }
}