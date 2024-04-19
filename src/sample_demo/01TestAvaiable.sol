// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 使⽤public 、private、external、internal 可⻅性关键字来控制变量和函数是否可以被外部使⽤。
// - public：内部、外部
// - private: 内部
// - external:外部访问
// - internal: 内部、继承
contract TestAvaiable {
    uint public data;
    constructor() {}

    function setData(uint x) internal {
        data = x;
    }

    function cal(uint a) public pure returns (uint) {
        return a + 1;
    }
}

//  1.Solidity 值类型
//  • 布尔、整型、定⻓浮点型、定⻓字节数组、枚举、函数类型、地址类型
//  • ⼗六进制常量、有理数和整型常量、字符串常量、地址常量
// 2.Solidity 引⽤类型
//   • 结构体
//  • 数组
// 3.映射类型
