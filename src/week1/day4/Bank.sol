// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Bank is Ownable {
    
    event Bank_deposit(address indexed sender, uint256 amount);

    // record every address deposit amount
    mapping(address => uint256) public balances;

    // record top3 deposit
    address[3] public top3Users;

    constructor(address initialOwner_) Ownable(initialOwner_) {}

    // withdraw balance by admin
    function withdraw(uint256 amount) public virtual onlyOwner {
        Address.sendValue(payable(msg.sender), amount);
    }

    function updateTop3User(address newSender) internal {
        // compare amount,if newSender is bigger,then update top3Users element
        if (balances[newSender] > balances[top3Users[0]]) {
            // if great than first element,move other elements and set newSender as first element
            top3Users[2] = top3Users[1];
            top3Users[1] = top3Users[0];
            top3Users[0] = newSender;
        } else if (balances[newSender] > balances[top3Users[1]]) {
            top3Users[2] = top3Users[1];
            top3Users[1] = newSender;
        } else {
            top3Users[2] = newSender;
        }
    }

    function getTop3User() public view returns (address[3] memory) {
        return top3Users;
    }

    receive() external payable virtual {
        balances[msg.sender] += msg.value;
        updateTop3User(msg.sender);

        emit Bank_deposit(msg.sender, msg.value);
    }

    fallback() external payable {}
}
