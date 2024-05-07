// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MyToken} from "../../../src/week4/day1/MyToken.sol";
import {MyERC721} from "../../../src/week4/day1/MyERC721.sol";
import {NFTMarket} from "../../../src/week4/day1/NFTMarketUpgrable.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

// forge script script/week4/day1/DeployNFTMarketV1.s.sol --rpc-url http://127.0.0.1:8545 --force
contract NFTMarketDeployScript is Script {
    function run() public returns (address) {
        // Use address provided in config to broadcast transactions
        vm.startBroadcast();
        MyToken erc20Token = new MyToken();
        MyERC721 erc721Token = new MyERC721();
        // Deploy the NFTMarket
        NFTMarket markert = new NFTMarket();
        // Log the markert address
        console.log("NFTMarket Implementation Address:", address(markert));
        // 部署代理合约
        // 方式1:推荐
        address proxy = Upgrades.deployUUPSProxy(
            "NFTMarketUpgrable.sol:NFTMarket",
            abi.encodeWithSelector(NFTMarket.initialize.selector, msg.sender, address(erc20Token), address(erc721Token))
        );
        vm.stopBroadcast();

        // 方式2:不推荐（旧版本）
        // ERC1967Proxy proxy = new ERC1967Proxy(
        //     address(markert),
        //     abi.encodeWithSelector(NFTMarket.initialize.selector, msg.sender, address(erc20Token), address(erc721Token))
        // );
        // Log the markert proxy address
        console.log("NFTMarket proxy Address:", address(proxy));
        return address(proxy);
    }
}

// forge script script/week4/day1/DeployNFTMarketV1.s.sol --rpc-url https://ethereum-sepolia.blockpi.network/v1/rpc/public --force --broadcast
