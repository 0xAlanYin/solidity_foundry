// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Hello {
    function sayHi() public pure returns (uint) {
        return 10;
    }
}

contract HelloCreator {
    uint public x;
    Hello public hello;

    function createHello() public returns (address) {
        hello = new Hello();
        return address(hello);
    }

    function callHi() public view returns (uint) {
        return hello.sayHi();
    }
}

contract TestType {
    // 经常需要区分一个地址是合约地址还是外部账号地址，区分的关键是看这个地址有没有与之相关联的代码。
    // EVM提供了一个操作码EXTCODESIZE，用来获取地址相关联的代码大小（长度），如果是外部账号地址，则没有代码返回。因此我们可以使用以下方法判断合约地址及外部账号地址
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
}
