// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {MyERC20Permit} from "../../../src/week3/day3/MyERC20Permit.sol";
import {TokenBank} from "../../../src/week3/day3/TokenBank.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import "./SignatureUtil.sol";

contract TokenBankEIP2612Test is Test {
    // 指定 owner 和 spender
    address internal owner;
    address internal spender;
    address internal otherUser;
    uint256 internal ownerPrivateKey = 1111;
    uint256 internal otherPrivateKey = 222;

    MyERC20Permit public token;
    SignatureUtil internal signatureUtil;

    TokenBank public tokenBank;

    function setUp() public {
        token = new MyERC20Permit();
        signatureUtil = new SignatureUtil(token.DOMAIN_SEPARATOR());

        // 初始化用户
        owner = vm.addr(ownerPrivateKey);
        otherUser = vm.addr(otherPrivateKey);

        // 给 owner 初始账户
        token.mint(owner, 1e18);

        tokenBank = new TokenBank(address(token));
        spender = address(tokenBank);
    }

    // 测试 permitDeposit 存款成功
    function testPermitDeposit_success() public {
        uint256 permitAmount = 1e18;
        SignatureUtil.Permit memory permit = SignatureUtil.Permit({
            owner: owner,
            spender: spender,
            value: permitAmount,
            nonce: 0,
            deadline: block.timestamp + 1 days
        });

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);

        console.log("token.balanceOf(owner):", token.balanceOf(owner));
        console.log("token.balanceOf(address(tokenBank):", token.balanceOf(address(tokenBank)));
        console.log("tokenBank.balanceOf(owner):", tokenBank.balanceOf(owner));
        assertEq(0, token.balanceOf(owner)); // owner 的钱全部转走，没有余额
        assertEq(1e18, token.balanceOf(address(tokenBank))); // owner 的钱全部转给了 tokenBank
        assertEq(1e18, tokenBank.balanceOf(owner)); // tokenBank 中 owner 的余额增加
    }

    function testPermitDeposit_succcess_when_permit_part_of_balance() public {
        uint256 permitAmount = 100;
        SignatureUtil.Permit memory permit = SignatureUtil.Permit({
            owner: owner,
            spender: spender,
            value: permitAmount,
            nonce: 0,
            deadline: block.timestamp + 1 days
        });

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);

        assertEq(999999999999999900, token.balanceOf(owner)); // owner 的钱全部转走，没有余额
        assertEq(100, token.balanceOf(address(tokenBank))); // owner 的钱全部转给了 tokenBank
        assertEq(100, tokenBank.balanceOf(owner)); // tokenBank 中 owner 的余额增加

        assertEq(1, token.nonces(owner));
    }

    function testPermitDeposit_failed_when_permit_expired() public {
        uint256 permitAmount = 100;
        SignatureUtil.Permit memory permit =
            SignatureUtil.Permit({owner: owner, spender: spender, value: permitAmount, nonce: 0, deadline: 1 days});

        vm.warp(1 days + 1 seconds);

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        vm.expectRevert(abi.encodeWithSelector(ERC20Permit.ERC2612ExpiredSignature.selector, 1 days)); // 过期，预期 revert
        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);
    }

    function testPermitDeposit_failed_when_signer_invalid() public {
        uint256 permitAmount = 100;
        SignatureUtil.Permit memory permit =
            SignatureUtil.Permit({owner: owner, spender: spender, value: permitAmount, nonce: 0, deadline: 1 days});

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(otherPrivateKey, digest); // 更换另一个不是owner的私钥

        vm.expectRevert(abi.encodeWithSelector(ERC20Permit.ERC2612InvalidSigner.selector, otherUser, owner)); //，预期 revert
        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);
    }

    function testPermitDeposit_failed_when_nonce_invalid() public {
        uint256 permitAmount = 100;
        SignatureUtil.Permit memory permit = SignatureUtil.Permit({
            owner: owner,
            spender: spender,
            value: permitAmount,
            nonce: 10, // set nonce 10, should be 0, will case revert
            deadline: 1 days
        });

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest); // 更换另一个不是owner的私钥

        vm.expectRevert(); //预期 revert
        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);
    }

    function testPermitDeposit_failed_when_exceed_owner_balance() public {
        uint256 permitAmount = 2e18;
        SignatureUtil.Permit memory permit =
            SignatureUtil.Permit({owner: owner, spender: spender, value: permitAmount, nonce: 0, deadline: 1 days});

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest); // 更换另一个不是owner的私钥

        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, owner, 1e18, 2e18)); //预期 revert
        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);
    }

    // test withdraw
    function testPermitWithdraw_success() public {
        uint256 permitAmount = 1e18;
        SignatureUtil.Permit memory permit =
            SignatureUtil.Permit({owner: owner, spender: spender, value: permitAmount, nonce: 0, deadline: 1 days});

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest); // 更换另一个不是owner的私钥

        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);

        vm.startPrank(owner);
        tokenBank.withdraw(1e18);
        assertEq(1e18, token.balanceOf(owner)); // owner 的钱全部转回
        assertEq(0, token.balanceOf(address(tokenBank))); // tokenBank 的钱全部转回
        assertEq(0, tokenBank.balanceOf(owner)); // tokenBank 中 owner 的余额减少
        vm.stopPrank();
    }

    function testPermitWithdraw_fail() public {
        uint256 permitAmount = 1e18;
        SignatureUtil.Permit memory permit =
            SignatureUtil.Permit({owner: owner, spender: spender, value: permitAmount, nonce: 0, deadline: 1 days});

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest); // 更换另一个不是owner的私钥

        tokenBank.permitDeposit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);

        vm.startPrank(owner);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, address(tokenBank), 1e18, 2e18));
        tokenBank.withdraw(2e18);
        vm.stopPrank();
    }
}
