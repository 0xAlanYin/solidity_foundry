// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract TestPayable {
    event Receiced(address, uint);

    receive() external payable {
        emit Receiced(msg.sender, msg.value);
    }

    function safeTransfer(address to, uint amount) public {
        (bool success, ) = to.call{value: amount}(new bytes(0));
        require(success, "Transfer failed");
    }

    uint public x;

    function unSafeTransfer(address payable to, uint amount) public {
        x = 10;
        to.transfer(amount);
    }
}

contract TestPayable2 {
    // 除了纯转账外，所有的调用都会调用这个函数
    // 因为除了receive函数外，没有其他的函数
    // 任何对合约非空calldata调用会执行回退函数(即使是调用函数附加以太)
    uint public x;
    uint public y;

    receive() external payable {
        x = 1;
        y = msg.value;
    }

    fallback() external payable {
        x = 2;
        y = msg.value;
    }
}

contract Caller {
    function callTest(address addr) public {
        (bool success, ) = addr.call(abi.encodeWithSignature("nonExist()"));
        require(success, "failed");
        //  test.x结果变成 == 1
        // address(test)不允许直接调用send, 因为test没有payable回退函数
        //  转化为address payable类型 , 然后才可以调用send
        address payable testPayable = payable(addr);
        testPayable.transfer(2 ether);
    }

    function callTestPayable(TestPayable2 test) public {
        (bool success, ) = address(test).call(
            abi.encodeWithSignature("nonExistingFunction()")
        );
        require(success);
        // test.x结果为 1，test.y结果为0
        (success, ) = address(test).call{value: 1}(
            abi.encodeWithSignature("nonExistingFunction()")
        );

        require(success);
        // test.x结果为1，test.y结果为1
        // 发送以太币，TestPayable的receive函数被调用
        require(payable(test).send(2 ether));
        // test.x结果为2，test.y结果为2 ether
    }
}
