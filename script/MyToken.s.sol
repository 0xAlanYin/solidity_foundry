// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/week2/MyDeployToken.sol";

contract MyTokenScript is Script {
    function setUp() public {}

    function run() public {
        MyToken token = new MyToken("CiCiToken", "CiT");

        console.log("token:", address(token));

        require(token.balanceOf(address(this)) == 1e10 * 1e18, "bad amount");
        vm.broadcast();
    }
}
