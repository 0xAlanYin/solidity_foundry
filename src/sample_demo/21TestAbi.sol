// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Counter {
    uint public count;
    address public addr;

    constructor() {
        count = 0;
    }

    function func1(uint param1, string memory param2) public {
        count += param1;
        string memory s = param2;
        addr = msg.sender;
    }

    function encodeWithSignature() public pure returns (bytes memory result) {
        uint param1 = 1;
        string memory param2 = "aaaa";
        return abi.encodeWithSignature("func1(uint,string)", param1, param2);
    }

    function encodeWithSignature2() public pure returns (string memory result) {
        return string(encodeWithSignature());
    }

    // abi.encodeWithSelector 函数用于根据函数选择器（函数签名的哈希值）生成对应的函数调用数据。
    function encodeWithSelector() public pure returns (bytes memory result) {
        uint param1 = 1;
        string memory param2 = "aaaa";
        return
            abi.encodeWithSelector(
                bytes4(keccak256("func1(uint,string)")),
                param1,
                param2
            );
    }

    function encodeWithSelector2() public pure returns (string memory result) {
        return string(encodeWithSelector());
    }
}

// ABI
// 底层函数：call，delegatecall，staticcall（不修改状态）
contract TestAbi {
    function call1() public {
        Counter c = new Counter();
        c.count();
    }

    function call2(address counter) public view {
        Counter(counter).count();
    }

    function call3(address counter, bytes memory paload) public {
        (bool success, ) = counter.call(paload); // 0x06661abd
        require(success, "want success,got failed");
    }

    function call4(address counter) public {
        bytes memory methodData = abi.encodeWithSignature("count()");
        (bool success, ) = counter.call(methodData);
        require(success, "want success,got failed");
    }
}

contract Transfer {
    function transfer1(address payable addr) public {
        // transfer 有 2300 gas费限制: 超过这个限制就无法向合约转账
        addr.transfer(1 ether);
    }

    function transfer2(address addr) public payable {
        addr.call{value: msg.value}(new bytes(0));
        // addr.call{value: msg.value}("");
    }

     receive() external payable {}
}
