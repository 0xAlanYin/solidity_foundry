// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {Bank} from "../../src/week1/day4/Bank2.sol";

contract BankTest is Test {
    event Withdrawed(address indexed user, uint256 amount);

    Bank public bank;

    // admin user
    address public adminUser = makeAddr("adminUser");
    // normal user
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public cindy = makeAddr("cindy");
    address public david = makeAddr("david");

    function setUp() public {
        bank = new Bank(adminUser);

        vm.deal(alice, 10 ether);
        vm.deal(bob, 20 ether);
        vm.deal(cindy, 10 ether);
        vm.deal(david, 10 ether);
    }

    function testDeposit2() public {
        vm.startPrank(alice);
        payable(bank).call{value: 1 ether}("");
        vm.stopPrank();
        assertEq(1 ether, address(bank).balance);

        vm.startPrank(bob);
        payable(bank).call{value: 3 ether}("");
        vm.stopPrank();
        assertEq(4 ether, address(bank).balance);
    }

    function testWithdraw2() public {
        vm.startPrank(alice);
        payable(bank).call{value: 2 ether}("");
        vm.stopPrank();

        vm.startPrank(bob);
        payable(bank).call{value: 3 ether}("");
        vm.stopPrank();

        vm.startPrank(alice);
        vm.expectRevert();
        bank.withdraw();
        vm.stopPrank();

        vm.startPrank(adminUser);
        bank.withdraw();
        vm.stopPrank();
        assertEq(0 ether, address(bank).balance);
        assertEq(5 ether, address(adminUser).balance);
    }

    function testGetTop3Users2() public {
        vm.startPrank(alice);
        payable(bank).call{value: 3 ether}("");
        vm.stopPrank();

        vm.startPrank(bob);
        payable(bank).call{value: 1 ether}("");
        vm.stopPrank();

        vm.startPrank(cindy);
        payable(bank).call{value: 2 ether}("");
        vm.stopPrank();

        vm.startPrank(david);
        payable(bank).call{value: 4 ether}("");
        vm.stopPrank();

        address[] memory users = bank.getTop3Users();
        console.log("Top3Users:", users[0]);
        console.log("Top3Users:", users[1]);
        console.log("Top3Users:", users[2]);
    }
}
