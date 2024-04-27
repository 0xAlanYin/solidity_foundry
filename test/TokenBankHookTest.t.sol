// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {MyToken} from "../src/week2/MyToken.sol";
import {TokenBank} from "../src/week2/TokenBankHook.sol";

contract TokenBankHookTest is Test {
    MyToken public token;
    TokenBank public tokenBank;

    address public bob = address(1);

    function setUp() public {
        token = new MyToken();
        tokenBank = new TokenBank(address(token));
    }

    function testTransferCallback_success() public {
        token.transfer(bob, 100);
        vm.startPrank(bob);
        bool succes = token.transferWithCallback(address(tokenBank), 1, new bytes(0));
        assertEq(true, succes);

        uint256 deposit = tokenBank.balanceOf(bob);
        assertEq(1, deposit);
        vm.stopPrank();
    }

    function testTransferCallback_faild_when_transfer_more_than_user_balance() public {
        token.transfer(bob, 100);
        vm.startPrank(bob);
        vm.expectRevert(abi.encodeWithSignature("ERC20InsufficientBalance(address,uint256,uint256)", bob, 100, 1000000));
        token.transferWithCallback(address(tokenBank), 1000000, new bytes(0));
        vm.stopPrank();
    }
}
