// SPDX-License-Identifier: UNLICENSED
pragma solidity >0.8.0;

// Solidity 使⽤地址类型来表示⼀个账号，地址类型有两种形式
// • address：⼀个20字节的值。
// • address payable：表示可⽀付地址，可调⽤transfer和send。
// 类型转换：address payable ap = payable(addr);
contract TestAddress {
    function testTransfer(address payable x) public {
        // 合约转换为地址类型
        address myAdress = address(this);
        if (myAdress.balance >= 10) {
            // 调⽤ x 的transfer ⽅法: 向 x 转10 wei
            x.transfer(10);
        }
    }

    // 给⼀个合约地址转账，即上⾯代码 x 是合约地址时，合约的receive函数或fallback函数会随着transfer调⽤⼀起执⾏
    receive() external payable {}

    fallback() external payable {}
}

// 成员函数
// • <address>.balance(uint256)： 返回地址的余额
// • <address payable>.transfer(uint256 amount)： 向地址发送以太币，失败时抛出异常 （gas：2300）
// • <address payable>.send(uint256 amount) returns (bool): 向地址发送以太币，失败时返回false （gas：2300）

