// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";
import "../src/week2/TokenBank.sol";
import "../src/week2/BaseERC20.sol";

contract TokenBankTest is Test {

    BaseERC20 erc20Token;
    TokenBank tokenBank;

    address alice = makeAddr("alice");

    function setUp() public {
        erc20Token = new BaseERC20();
        // 给 alice 账户转 100000 代币
        erc20Token.transfer(alice, 100000);
        tokenBank = new TokenBank(address(erc20Token));
    }

    function testDeposit_success() public {
        vm.startPrank(alice);
        // alice 授权 tokenBank 转账
        erc20Token.approve(address(tokenBank), 100000);
        tokenBank.deposit(100);

        uint256 deposit = tokenBank.balanceOf(alice);
        assertEq(100, deposit, "alice amount not eq 100");
        vm.stopPrank();
    }

    function testDeposit_failed_when_amount_exceeds_allowance() public {
        vm.startPrank(alice);
        erc20Token.approve(address(tokenBank), 10);

        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        tokenBank.deposit(100);
        vm.stopPrank();
    }

    function testWithdraw_success() public {
        vm.startPrank(alice);
        // alice 授权 tokenBank 转账
        erc20Token.approve(address(tokenBank), 100000);
        tokenBank.deposit(100);


        tokenBank.withdraw(99);
        uint256 deposit = tokenBank.balanceOf(alice);
        assertEq(1, deposit, "alice amount deposit not eq 1");
        vm.stopPrank();
    }

    function testWithdraw__failed_when_amount_exceeds_deposit() public {
        vm.startPrank(alice);
        // alice 授权 tokenBank 转账
        erc20Token.approve(address(tokenBank), 100000);
        tokenBank.deposit(100);

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        tokenBank.withdraw(101);
        vm.stopPrank();
    }

}