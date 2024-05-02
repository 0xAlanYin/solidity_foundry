// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {MyEIP2612} from "../src/week3/MyEIP2612.sol";
import {TokenBank} from "../src/week3/TokenBankEIP2612.sol";
import "./SignatureUtil.sol";

contract TokenBankEIP2612Test is Test {
    // 指定 owner 和 spender，并指定对应的Mock私钥
    address internal owner;
    address internal spender;
    uint256 internal ownerPrivateKey;
    uint256 internal spenderPrivateKey;

    MyEIP2612 public token;
    SignatureUtil internal signatureUtil;

    TokenBank public tokenBank;

    function setUp() public {
        token = new MyEIP2612();
        signatureUtil = new SignatureUtil(token.DOMAIN_SEPARATOR());

        // 初始化用户
        ownerPrivateKey = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
        spenderPrivateKey = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        owner = vm.addr(ownerPrivateKey);

        // 给 owner 转初始账户
        token.transfer(owner, 1000000);

        tokenBank = new TokenBank(address(token));
        spender = address(tokenBank);
    }

    // 测试 permitDeposit
    function testPermitDeposit_success() public {
        // uint256 nonce = 0;
        // uint256 deadline = block.timestamp + 1000;
        // SignatureUtil.Permit memory permit = SignatureUtil.Permit(owner, spender, 10000, nonce, deadline);

        // bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        // (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        // console.log("owner:%s", owner);
        // console.log("spender:%s", spender);
        // console.log("tokenBank:", address(tokenBank));

        // vm.startPrank(spender);
        // tokenBank.permitDeposit(owner, 1000, deadline, v, r, s);
        // assertEq(1000, tokenBank.balanceOf(owner), "owner balance should be 1000");
        // vm.stopPrank();
    }
}
