// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.24 and less than 0.9.0
pragma solidity ^0.8.24;

// Event-Driven Architecture
contract EventDrivenArchitecture {
    event TranferInitiated(address indexed from, address indexed to, uint256 value);
    event TransferConfirmed(address indexed from, address indexed to, uint256 value);

    mapping(bytes32 => bool) public transferConfirmations;

    // initiateTransfer
    function initiateTransfer(address to, uint256 amount) public {
        emit TranferInitiated(msg.sender, to, amount);
        // businiess logic
    }

    // confirmTranser
    function confirmTransfer(bytes32 transferId) public {
        require(!transferConfirmations[transferId], "transfer is already confirmed");

        transferConfirmations[transferId] = true;
        emit TransferConfirmed(msg.sender, address(this), 0);
        // businiess logic
    }
}

// Event Subscription and Real-Time Updates
interface IEventSubscriber {
    function handleTransferEvent(address from, address to, uint256 value) external;
}

contract EventSubscription {
    event LogTransfer(address indexed from, address indexed to, uint256 amount);

    mapping(address => bool) public subscribes;
    address[] public subscriberList;

    // subscribe
    function subscribe() public {
        address sender = msg.sender;
        require(!subscribes[sender], "Already subscibe");

        subscribes[sender] = true;
        subscriberList.push(sender);
    }

    // unsubscribe
    function unsubscribe() public {
        address sender = msg.sender;
        require(subscribes[sender], "Not subscibed");

        subscribes[sender] = false;
        for (uint256 i = 0; i < subscriberList.length; i++) {
            if (subscriberList[i] == sender) {
                subscriberList[i] = subscriberList[subscriberList.length - 1];
                subscriberList.pop();
                break;
            }
        }
    }
}
