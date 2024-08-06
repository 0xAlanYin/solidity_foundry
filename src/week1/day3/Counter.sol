// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Counter {
    event Counter_AddNumber(uint256 number);

    uint256 public counter;

    function add(uint256 x) public {
        counter += x;

        emit Counter_AddNumber(x);
    }

    function get() public view returns (uint256) {
        return counter;
    }
}
