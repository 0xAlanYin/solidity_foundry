// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// 错误处理
// • 在程序发⽣错误时的处理⽅式：EVM通过回退状态来处理错误的，以便保证状态修改的事务性
// • assert()和require()⽤来进⾏条件检查，并在条件不满⾜时抛出异常
// • revert(“msg”)：终⽌运⾏并撤销状态更改
// • Error 定义错误
contract TestError {
    address public owner;

    uint x;

    constructor() {
        owner = msg.sender;
    }

    error NotOwner();

    error OtherError(string message);

    function withdraw(uint amount) public payable {
        if (msg.sender != owner) revert NotOwner(); // 23388

        // if (msg.sender != owner) revert OtherError("err msg");

        require(msg.sender == owner, "Not owner 00000000000000"); // 23642

        x += 1;
        assert(x > 1);
    }
}
