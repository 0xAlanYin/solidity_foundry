// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {MultipleContractWallet} from "../../../src/week5/day5/MultipleContractWallet.sol";
import {ERC20Mock} from "openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract MultipleContractWalletTest is Test {
    MultipleContractWallet multipleContractWallet;

    address whitelistUser1 = makeAddr("alice");
    address whitelistUser2 = makeAddr("bob");
    address whitelistUser3 = makeAddr("cindy");
    address whitelistUser4 = makeAddr("david");
    address whitelistUser5 = makeAddr("eva");

    address nootWhitelistUser = makeAddr("Katy");

    address to;
    ERC20Mock token; // for test target contract

    function setUp() public {
        address[] memory whitelist = new address[](5);
        whitelist[0] = whitelistUser1;
        whitelist[1] = whitelistUser2;
        whitelist[2] = whitelistUser3;
        whitelist[3] = whitelistUser4;
        whitelist[4] = whitelistUser5;
        uint8 threshold = 3;
        multipleContractWallet = new MultipleContractWallet(whitelist, threshold);

        token = new ERC20Mock();
        to = address(token);

        vm.deal(whitelistUser1, 10 ether);
    }

    // test submitProposal
    function test_submitProposal_success() public {
        vm.startPrank(whitelistUser1);
        uint256 value1 = 10000;
        bytes memory data1 = "";
        multipleContractWallet.submitProposal(to, value1, data1);

        (address to2, bytes memory data, uint256 value, uint256 voteCount) =
            multipleContractWallet.getProposalInfo(whitelistUser1);
        assertTrue(to2 != address(0));
        assertEq(to, to2);
        assertEq("", data);
        assertEq(10000, value);
        assertEq(0, voteCount);
        vm.stopPrank();
    }

    function test_submitProposal_failed_when_no_in_whitelist() public {
        vm.startPrank(nootWhitelistUser);
        uint256 value = 10000;
        bytes memory data = "";
        vm.expectRevert("send user not in whitelist");
        multipleContractWallet.submitProposal(to, value, data);
        vm.stopPrank();
    }

    function test_comfirmProposal_success() public {
        vm.startPrank(whitelistUser1);
        uint256 value1 = 10000;
        bytes memory data1 = "";
        multipleContractWallet.submitProposal(to, value1, data1);
        vm.stopPrank();

        vm.startPrank(whitelistUser2);
        multipleContractWallet.comfirmProposal(whitelistUser1);
        (address to2, bytes memory data, uint256 value, uint256 voteCount) =
            multipleContractWallet.getProposalInfo(whitelistUser1);

        assertTrue(to2 != address(0));
        assertEq(to, to2);
        assertEq("", data);
        assertEq(10000, value);
        assertEq(1, voteCount);
        vm.stopPrank();
    }

    function test_comfirmProposal_failed_when_proposal_not_exist() public {
        vm.startPrank(whitelistUser1);
        uint256 value = 10000;
        bytes memory data = "";
        multipleContractWallet.submitProposal(to, value, data);
        vm.stopPrank();

        vm.startPrank(whitelistUser2);
        vm.expectRevert("proposal not exist");
        multipleContractWallet.comfirmProposal(whitelistUser3);
        vm.stopPrank();
    }

    // test excuteTransaction
    function test_excuteTransaction_success() public {
        vm.startPrank(whitelistUser1);
        uint256 value = 0;
        bytes memory data = abi.encodeWithSignature("mint(address,uint256)", whitelistUser1, 1000);
        multipleContractWallet.submitProposal(to, value, data);
        vm.stopPrank();

        // voteCount=1
        vm.startPrank(whitelistUser1);
        multipleContractWallet.comfirmProposal(whitelistUser1);
        vm.stopPrank();

        // voteCount=2
        vm.startPrank(whitelistUser2);
        multipleContractWallet.comfirmProposal(whitelistUser1);
        vm.stopPrank();

        // voteCount=3
        vm.startPrank(whitelistUser3);
        multipleContractWallet.comfirmProposal(whitelistUser1);
        vm.stopPrank();

        vm.startPrank(whitelistUser1);
        multipleContractWallet.excuteTransaction(whitelistUser1);
        assertEq(1000, token.balanceOf(whitelistUser1));
        vm.stopPrank();
    }

    function test_excuteTransaction_failed_when_vote_count_not_enough() public {
        vm.startPrank(whitelistUser1);
        uint256 value = 0;
        bytes memory data = abi.encodeWithSignature("mint(address,uint256)", whitelistUser1, 1000);
        multipleContractWallet.submitProposal(to, value, data);
        vm.stopPrank();

        // voteCount=1
        vm.startPrank(whitelistUser1);
        multipleContractWallet.comfirmProposal(whitelistUser1);
        vm.stopPrank();

        // voteCount=2
        vm.startPrank(whitelistUser2);
        multipleContractWallet.comfirmProposal(whitelistUser1);
        vm.stopPrank();

        vm.startPrank(whitelistUser1);
        vm.expectRevert("not reach threshold");
        multipleContractWallet.excuteTransaction(whitelistUser1);
        vm.stopPrank();
    }
}
