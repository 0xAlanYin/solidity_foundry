// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 函数：
// function + 函数名(参数列表) + 可见性 + 状态可变性(可多个) + 返回值

// 状态可变性：
// • view：表示函数只读取状态
// • pure：表示函数不读取状态、也不写（状态）， 仅计算
// • payable: 表示函数可接收以太币
//      ⽀付的 ETH 值，⽤ msg.value 获取

// 合约特殊函数:
// • 构造函数(constructor): 初始化逻辑
// • getter 函数: 所有 public 状态变量创建 getter 函数
// • receive 函数: 接收以太币时回调。
// • fallback 函数: 没有匹配函数标识符时, fallback 会被调⽤，如果是转账时，没有 receive 也有调⽤ fallback

// • receive / fallback 充当回调函数作⽤
// • 回调函数：有转账了，告诉我（合约）⼀下
contract TestFunction {
    uint public count;
    constructor() {}

    function functionName(
        uint param1,
        string memory param2
    ) public view returns (uint) {
        return 1;
    }

    // 没有的时候，无法接收ETH
    receive() external payable {}

    fallback() external payable {}
}
