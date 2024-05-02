// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {MyEIP2612} from "../src/week3/MyEIP2612.sol";
import "./SignatureUtil.sol";

contract MyEIP2612Test is Test {
    // 指定 owner 和 spender，并指定对应的Mock私钥
    address internal owner;
    address internal spender;
    address internal anotherUser;
    uint256 internal ownerPrivateKey;
    uint256 internal spenderPrivateKey;

    uint256 internal anotherPrivateKey;

    MyEIP2612 public token;
    SignatureUtil internal signatureUtil;

    function setUp() public {
        token = new MyEIP2612();
        signatureUtil = new SignatureUtil(token.DOMAIN_SEPARATOR());

        ownerPrivateKey = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
        spenderPrivateKey = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        anotherPrivateKey = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567111;

        owner = vm.addr(ownerPrivateKey);
        spender = vm.addr(spenderPrivateKey);
        anotherUser = vm.addr(anotherPrivateKey);

        token.transfer(owner, 1000000);
    }

    // 测试 MyEIP2612 的 permit
    function testPermit_success() public {
        uint256 nonce = 0;
        uint256 deadline = block.timestamp + 1000;
        SignatureUtil.Permit memory permit = SignatureUtil.Permit(owner, spender, 10000, nonce, deadline);

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        token.permit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);

        assertEq(10000, token.allowance(owner, spender), "owner should permit spender 10000 success");
        assertEq(1, token.nonces(owner), "nonce should eq 1");
    }

    function testPermit_failed_when_use_another_private_key() public {
        uint256 nonce = token.nonces(anotherUser);
        uint256 deadline = block.timestamp + 10 days;
        SignatureUtil.Permit memory permit = SignatureUtil.Permit(anotherUser, spender, 10000, nonce, deadline);

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(anotherPrivateKey, digest);

        vm.expectRevert();
        // ERC2612InvalidSigner(address,address)
        // vm.expectRevert(abi.encodeWithSignature("ERC2612InvalidSigner(address,address)", "0x8C40710CbB5C76AD076e25a315B5fc928795CA12", anotherUser));
        token.permit(owner, spender, 100, deadline, v, r, s);
    }

    function test_Permit() public {
        SignatureUtil.Permit memory permit = SignatureUtil.Permit({
            owner: owner,
            spender: spender,
            value: 1e18,
            nonce: 0,
            deadline: block.timestamp + 1 days
        });

        bytes32 digest = signatureUtil.caculateTypeDataHash(permit);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        token.permit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);

        assertEq(token.allowance(owner, spender), 1e18);
        assertEq(token.nonces(owner), 1);
    }
}
