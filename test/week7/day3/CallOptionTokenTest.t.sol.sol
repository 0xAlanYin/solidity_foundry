// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {CallOptionToken} from "../../../src/week7/day3/CallOptionToken.sol";
import {USDT} from "../../../src/week7/day3/USDT.sol";

contract CallOptionTokenTest is Test {
    CallOptionToken callOptionToken;
    USDT usdt;

    address usdtOwner = makeAddr("usdtOwner");
    address callOptionTokenOwner = makeAddr("callOptionTokenOwner");

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address cindy = makeAddr("cindy");

    function setUp() public {
        vm.startPrank(usdtOwner);
        usdt = new USDT("USDT", "USDT", usdtOwner);

        usdt.mint(alice, 600000);
        usdt.mint(bob, 600000);
        usdt.mint(cindy, 6000000);
        vm.stopPrank();

        vm.startPrank(callOptionTokenOwner);
        vm.warp(800);
        callOptionToken =
            new CallOptionToken("CallOptionToken", "COT", 4000, 100, 2000, 1000, callOptionTokenOwner, address(usdt));
        vm.stopPrank();

        vm.deal(callOptionTokenOwner, 100000);
    }

    function testDeposit() public {
        vm.warp(900);
        vm.startPrank(alice);
        usdt.approve(address(callOptionToken), 1000);
        callOptionToken.deposit(1000);
        vm.stopPrank();

        assertEq(usdt.balanceOf(callOptionTokenOwner), 1000);
    }

    // test issue
    function testIssue() public {
        vm.warp(900);
        vm.startPrank(alice);
        usdt.approve(address(callOptionToken), 1000);
        callOptionToken.deposit(1000);
        vm.stopPrank();

        vm.startPrank(bob);
        usdt.approve(address(callOptionToken), 2000);
        callOptionToken.deposit(2000);
        vm.stopPrank();

        vm.startPrank(cindy);
        usdt.approve(address(callOptionToken), 3000);
        callOptionToken.deposit(3000);
        vm.stopPrank();

        vm.warp(1200);
        vm.startPrank(callOptionTokenOwner);
        callOptionToken.issue{value: 60}();
        vm.stopPrank();

        assertEq(callOptionToken.totalSupply(), 60);
    }

    // test exercise
    function testExercise() public {
        vm.warp(900);
        vm.startPrank(alice);
        usdt.approve(address(callOptionToken), 1000);
        callOptionToken.deposit(1000);
        vm.stopPrank();

        vm.startPrank(bob);
        usdt.approve(address(callOptionToken), 2000);
        callOptionToken.deposit(2000);
        vm.stopPrank();

        vm.startPrank(cindy);
        usdt.approve(address(callOptionToken), 3000);
        callOptionToken.deposit(3000);
        vm.stopPrank();

        vm.warp(1200);
        vm.startPrank(callOptionTokenOwner);
        callOptionToken.issue{value: 60}();
        vm.stopPrank();

        vm.warp(2000);
        vm.startPrank(alice);
        usdt.approve(address(callOptionToken), 400000000);
        callOptionToken.exercise(40000);
        vm.stopPrank();
        assertEq(alice.balance, 10);
    }

    // test redeem
    function testRedeem() public {
        vm.warp(900);
        vm.startPrank(alice);
        usdt.approve(address(callOptionToken), 1000);
        callOptionToken.deposit(1000);
        vm.stopPrank();

        vm.startPrank(bob);
        usdt.approve(address(callOptionToken), 2000);
        callOptionToken.deposit(2000);
        vm.stopPrank();

        vm.startPrank(cindy);
        usdt.approve(address(callOptionToken), 3000);
        callOptionToken.deposit(3000);
        vm.stopPrank();

        vm.warp(1200);
        vm.startPrank(callOptionTokenOwner);
        callOptionToken.issue{value: 100}(); // 100 more than 60(actual needed)
        vm.stopPrank();

        vm.warp(2000);
        vm.startPrank(alice);
        usdt.approve(address(callOptionToken), 400000000);
        callOptionToken.exercise(40000); // 1000/100 * 4000 = 40000
        vm.stopPrank();

        vm.startPrank(bob);
        usdt.approve(address(callOptionToken), 400000000);
        callOptionToken.exercise(80000);
        vm.stopPrank();

        vm.startPrank(cindy);
        usdt.approve(address(callOptionToken), 400000000);
        callOptionToken.exercise(120000); // 3000/100 * 4000 = 120000
        vm.stopPrank();

        vm.startPrank(callOptionTokenOwner);

        callOptionToken.redeem();
        vm.stopPrank();
        assertEq(callOptionTokenOwner.balance, 99940); // 100000 - 100 + 40 = 99940
    }
}
