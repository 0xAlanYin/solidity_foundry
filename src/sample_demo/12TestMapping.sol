// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 映射
// • 声明形式： mapping(KeyType => ValueType) ， 例如：mapping(address => uint) public balances;
// • 使⽤⽅式类似数组，通过 key 访问，例如： balances[userAddr];
// • 映射没有⻓度、没有 key 的集合或 value 的集合的概念
// • 只能作为状态变量（storage）
// • 如果访问⼀个不存在的键，返回的是默认值。
contract TestMapping {
    mapping(address => uint) public balances;

    function update(uint amount) public {
        balances[msg.sender] = amount;
    }

    function get(address addr) public view returns (uint) {
        return balances[addr];
    }
}
