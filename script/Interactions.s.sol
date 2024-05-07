// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.19;

// import {Script, console} from "forge-std/Script.sol";
// import {FundMe} from "../src/custom_test/FundMe.sol";
// import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

// contract FundFundMe is Script {
//     uint256 SEND_VALUE = 0.1 ether;

//     function run() external {
//         address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
//         fundFundMe(mostRecentlyDeployed);
//     }

//     function fundFundMe(address mostRecentlyDeployed) public {
//         vm.startBroadcast();
//         FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
//         vm.stopBroadcast();
//         console.log("Funded FundMe with %s", SEND_VALUE);
//     }
// }

// contract WithdrawFundMe is Script {
//     function withdrawFundMe(address mostRecentlyDeployed) public {
//         vm.startBroadcast();
//         FundMe(payable(mostRecentlyDeployed)).withdraw();
//         vm.stopBroadcast();
//         console.log("Withdraw FundMe balance!");
//     }

//     function run() external {
//         address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
//         withdrawFundMe(mostRecentlyDeployed);
//     }
// }
