// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test} from "forge-std/Test.sol";

import {Counter} from "../../src/week1/day3/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
    }

    function testAdd() public {
        counter.add(1);

        assertEq(1, counter.get());
    }
}
