// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Bank is Ownable {
    event Deposited(address indexed user, uint256 amount);
    event Withdrawed(address indexed user, uint256 amount);

    mapping(address => uint256) public balances;

    address[] public top3Users;

    constructor(address owner) Ownable(owner) {}

    receive() external payable virtual {
        // check
        uint256 amount = msg.value;
        require(amount > 0, "depoist amount must greater than 0");

        // increase balance
        address user = msg.sender;
        balances[user] += amount;

        // update top3 user
        _updateTop3User(user, balances[user]);

        // send event
        emit Deposited(user, balances[user]);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        (bool ok,) = payable(msg.sender).call{value: balance}("");
        require(ok, "required success");

        emit Withdrawed(msg.sender, balance);
    }

    function _updateTop3User(address user, uint256 amount) internal {
        if (top3Users.length < 3) {
            top3Users.push(user);
        } else {
            // find exist min amount 's index
            uint256 minIndx = 0;
            for (uint256 i = 1; i < 3; i++) {
                if (balances[top3Users[i]] < balances[top3Users[minIndx]]) {
                    minIndx = i;
                }
            }

            // compare current amount,if current amount bigger,update
            if (balances[top3Users[minIndx]] < amount) {
                top3Users[minIndx] = user;
            }
        }
    }

    function getTop3Users() public view returns (address[] memory) {
        return top3Users;
    }
}
