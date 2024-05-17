// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

// 实现⼀个简单的多签合约钱包，合约包含的功能：
// 1.创建多签钱包时，确定所有的多签持有⼈和签名门槛
// 2.多签持有⼈可提交提案
// 3.其他多签⼈确认提案（使⽤交易的⽅式确认即可）
// 4.达到多签⻔槛、任何⼈都可以执⾏交易
contract MultipleContractWallet {
    // event
    event ProposalSubmitted(address indexed proposalUser, address indexed to, bytes data);
    event ProposalConfirmed(address indexed user);
    event TransactionExecuted(address indexed proposer, address indexed executor);

    struct ProposalInfo {
        address to;
        bytes data;
        uint256 value;
        uint256 voteCount;
        mapping(address => bool) votedUser;
    }

    mapping(address => bool) _whitelist;
    uint8 _threshold;
    uint256 _whitelistSize;
    mapping(address => ProposalInfo) public userProposals;

    constructor(address[] memory whitelist_, uint8 threshold_) {
        require(whitelist_.length > 0, "whitelist size must gt 0");
        require(threshold_ > 0, "threshold must gt 0");
        require(threshold_ <= whitelist_.length, "threshold must lte whitelist size");

        for (uint256 i = 0; i < whitelist_.length; i++) {
            _whitelist[whitelist_[i]] = true;
        }
        _threshold = threshold_;
        _whitelistSize = whitelist_.length;
    }

    // submmit proposal
    function submitProposal(address to, uint256 value, bytes calldata data) public {
        // check user is in whitelist
        address user = msg.sender;
        require(_whitelist[user], "send user not in whitelist");

        // override history proposal
        ProposalInfo storage proposalInfo = userProposals[user];
        proposalInfo.to = to;
        proposalInfo.data = data;
        proposalInfo.value = value;
        proposalInfo.voteCount = 0;

        emit ProposalSubmitted(user, to, data);
    }

    // comfirm proposal
    function comfirmProposal(address proposer) public {
        // check user is in whitelist
        address user = msg.sender;
        require(_whitelist[user], "send user not in whitelist");

        // check proposal exist
        ProposalInfo storage proposalInfo = userProposals[proposer];
        require(proposalInfo.to != address(0), "proposal not exist");

        // check user is alreay vote
        require(!proposalInfo.votedUser[user], "user already voted");

        // voteCount +1
        proposalInfo.voteCount += 1;
        // record voted user
        proposalInfo.votedUser[user] = true;

        emit ProposalConfirmed(user);
    }

    function excuteTransaction(address proposer) public {
        // check proposal exist
        ProposalInfo storage proposalInfo = userProposals[proposer];
        require(userProposals[proposer].to != address(0), "proposal not exist");

        // check voteCount >= threshold
        require(proposalInfo.voteCount >= _threshold, "not reach threshold");

        // excute transaction
        (bool success,) = proposalInfo.to.call{value: proposalInfo.value}(proposalInfo.data);
        require(success, "transaction failed");

        emit TransactionExecuted(proposer, msg.sender);
    }

    function getProposalInfo(address user)
        external
        view
        returns (address to, bytes memory data, uint256 value, uint256 voteCount)
    {
        ProposalInfo storage proposalInfo = userProposals[user];
        return (proposalInfo.to, proposalInfo.data, proposalInfo.value, proposalInfo.voteCount);
    }
}
