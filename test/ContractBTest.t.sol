// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Test.sol";

contract ContractBaseTest is Test {
    uint256 number;

    function setUp() public {
        number = 42;
    }

    function testNumberIs42() public view {
        assertEq(number, 42);
    }

    function testFailSubtract42() public {
        number -= 43;
    }
}
