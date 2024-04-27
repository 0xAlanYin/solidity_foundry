pragma solidity 0.8.25;

contract Counter {
    uint256 public counter;
    address public sender;

    function count() public {
        counter += 1;
        sender = msg.sender;
    }

    fallback() external payable {}
}

contract CallTest {
    uint256 public counter;
    address public sender;

    function callCount(Counter c) public {
        c.count();
    }

    // 只是调用代码，合约环境还是当前合约。
    function lowDelegatecallCount(address addr) public {
        bytes memory methodData = abi.encodeWithSignature("count()");
        addr.delegatecall(methodData);
    }

    function lowCallCount(address addr) public {
        bytes memory methodData = abi.encodeWithSignature("count()");
        addr.call(methodData);
        // addr.call{gas:1000}(methodData);
        // addr.call{gas:1000, value: 1 ether}(methodData);
    }
}
