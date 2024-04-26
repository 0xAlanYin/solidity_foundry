// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// 错误处理
// • 在程序发⽣错误时的处理⽅式：EVM通过回退状态来处理错误的，以便保证状态修改的事务性
// • assert()和require()⽤来进⾏条件检查，并在条件不满⾜时抛出异常
// • revert(“msg”)：终⽌运⾏并撤销状态更改
// • Error 定义错误
contract TestError {
    address public owner;

    uint256 x;

    constructor() {
        owner = msg.sender;
    }

    error NotOwner();

    error OtherError(string message);

    function withdraw(uint256 amount) public payable {
        // 推荐使用第一种形式，自定义错误的方式来触发，因为只需要使用 4 个字节的编码就可以描述错误，比较使用解释性的字符串消耗更少的GAS。
        // 形式1:
        if (msg.sender != owner) revert NotOwner(); // 23388
        // 形式2:
        // if (msg.sender != owner) revert OtherError("err msg");

        //功能上与上面等价，但是形式1消耗更少的 gas 费用
        require(msg.sender == owner, "Not owner 00000000000000"); // 23642

        x += 1;
        assert(x > 1);
    }
}
