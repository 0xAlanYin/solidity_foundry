// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {MyToken} from "../../../src/week7/day2/MyToken.sol";
import {Bank} from "../../../src/week7/day2/Bank.sol";
import {MyGovernor} from "../../../src/week7/day2/Governor.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract GoveranceTest is Test {
    MyToken myToken;
    Bank bank;
    MyGovernor myGovernor;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address cindy = makeAddr("cindy");

    address tokenDeployer = makeAddr("tokenDeployer");
    address myGovernorDeployer = makeAddr("myGovernorDeployer");

    address proposer1 = makeAddr("proposer1");
    address proposer2 = makeAddr("proposer2");
    address proposer3 = makeAddr("proposer3");
    address proposer4 = makeAddr("proposer4");
    address executors1 = makeAddr("executors1");
    address executors2 = makeAddr("executors2");
    address executors3 = makeAddr("executors3");
    address admin = makeAddr("admin");

    enum VoteType {
        Against,
        For,
        Abstain
    }

    function setUp() public {
        // deploy MyToken
        vm.startPrank(tokenDeployer);
        myToken = new MyToken();

        myToken.transfer(alice, 1e7 ether);
        myToken.transfer(bob, 1e7 ether);
        myToken.transfer(cindy, 1e7 ether);
        vm.stopPrank();

        // deploy MyGovernor
        vm.startPrank(myGovernorDeployer);
        address[] memory proposers = new address[](4);
        proposers[0] = proposer1;
        proposers[1] = proposer2;
        proposers[2] = proposer3;
        proposers[3] = proposer4;
        address[] memory executors = new address[](3);
        executors[0] = executors1;
        executors[1] = executors2;
        executors[2] = executors3;
        TimelockController timelock = new TimelockController(1 days, proposers, executors, admin);

        myGovernor = new MyGovernor(IVotes(myToken), timelock);

        // deploy Bank
        bank = new Bank(address(myGovernor));
        vm.stopPrank();

        // prepare user money
        vm.deal(alice, 1 ether);
        vm.deal(bob, 1 ether);
        vm.deal(cindy, 1 ether);
    }

    // test proposal
    function testProposal() public {
        // 1.prepare money deposit
        vm.startPrank(alice);
        bank.deposit{value: 10000}();
        vm.stopPrank();

        vm.startPrank(bob);
        bank.deposit{value: 10000}();
        vm.stopPrank();

        // 2.propose
        vm.startPrank(proposer1);
        address[] memory targets = new address[](1);
        targets[0] = address(bank);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encode("withdraw", 10000);
        string memory description = "withdraw 10000";
        uint256 proposalId = myGovernor.propose(targets, values, calldatas, description);
        vm.stopPrank();

        // 3.vote
        vm.startPrank(alice);
        myGovernor.castVote(proposalId, uint8(VoteType.For));
        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = myGovernor.proposalVotes(proposalId);
        assertEq(againstVotes, 0, "againstVotes should be 1");
        assertEq(forVotes, 1, "forVotes should be 1");
        assertEq(abstainVotes, 0, "abstainVotes should be 0");
        vm.stopPrank();

        vm.startPrank(bob);
        myGovernor.castVote(proposalId, 1);
        vm.stopPrank();

        vm.startPrank(cindy);
        myGovernor.castVote(proposalId, 1);
        vm.stopPrank();

        // 4.queue
        myGovernor.queue(targets, values, calldatas, keccak256(abi.encode(description)));
        assertEq(bank.balances(address(this)), 20000, "bank balance should be 20000");

        // 5.execute
        myGovernor.execute(targets, values, calldatas, keccak256(abi.encode(description)));
        assertEq(bank.balances(address(this)), 10000, "bank balance should be 10000");
    }
}
