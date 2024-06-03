// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

// AutomationCompatible.sol imports the functions from both ./AutomationBase.sol and
// ./interfaces/AutomationCompatibleInterface.sol
import {AutomationCompatibleInterface} from "@chainlink/src/v0.8/automation/AutomationCompatible.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract Bank is AutomationCompatibleInterface {
    event Bank_Deposit(address indexed user, uint256 amount);
    event Bank_Transfer(address indexed user, uint256 amount);

    mapping(address => uint256) public deposits;
    uint256 public withdrawThreshold;
    address public owner;

    constructor(uint256 withdrawThreshold_, address initialOwner_) {
        withdrawThreshold = withdrawThreshold_;
        owner = initialOwner_;
    }

    function deposit() external payable {
        uint256 amount = msg.value;
        require(amount > 0, "deposit amount must gt 0");
        address user = msg.sender;
        deposits[user] += amount;

        emit Bank_Deposit(user, amount);
    }

    function checkUpkeep(bytes calldata checkData)
        external
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        upkeepNeeded = address(this).balance >= withdrawThreshold;
    }

    function performUpkeep(bytes calldata performData) external override {
        if (address(this).balance >= withdrawThreshold) {
            uint256 amount = address(this).balance / 2;
            Address.sendValue(payable(owner), amount);
            emit Bank_Transfer(owner, amount);
        }
    }
}
