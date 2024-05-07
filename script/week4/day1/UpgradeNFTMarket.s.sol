// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MyToken} from "../../../src/week4/day1/MyToken.sol";
import {MyERC721} from "../../../src/week4/day1/MyERC721.sol";
import {NFTMarket} from "../../../src/week4/day1/NFTMarketUpgrable.sol";
import {NFTMarketV2} from "../../../src/week4/day1/NFTMarketUpgrableV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

// forge script script/week4/day1/UpgradeNFTMarket.s.sol --rpc-url http://127.0.0.1:8545 --force
contract UUPSUpgradeNFTMarketScript is Script {
    function run() public {
        address rencentDeployedProxy = 0xFe4CEc366378abD0ea4A99349297ACa86EB74069; // Replace with your nftmarket proxy address
        vm.startBroadcast();
        // 升级代理合约
        Upgrades.upgradeProxy(
            rencentDeployedProxy,
            "NFTMarketUpgrableV2.sol:NFTMarketV2",
            ""
        );
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(rencentDeployedProxy));
        vm.stopBroadcast();
    }

}
// forge script script/week4/day1/UpgradeNFTMarket.s.sol --rpc-url https://ethereum-sepolia.blockpi.network/v1/rpc/public --force --broadcast

// cast call 0x13A1E2e2fF14FdC94EE6fB0d37c147B4e49D04C0  "getImplementation()returns(address)"

// cast call 0xFe4CEc366378abD0ea4A99349297ACa86EB74069  "owner()returns(address)" 