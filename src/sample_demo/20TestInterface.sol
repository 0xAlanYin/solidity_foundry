// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

interface ICounter {
    function increment() external;
    function count() external view returns (uint256);
}

contract Counter {
    uint256 public count;

    function increment() public {
        count += 1;
    }
}

contract TestUse {
    function incrementCounter(address _counter) public {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) public view returns (uint256) {
        return ICounter(_counter).count();
    }
}
