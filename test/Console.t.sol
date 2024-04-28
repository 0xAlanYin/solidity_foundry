// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

contract ConsoleTest is Test {
    address Bob = address(1);

    uint256 START_BALANCE = 1 ether;

    function setUp() public {}

    function testConsolePrint() public {
        console.log("%s:%s", "key", "value");
        console.log("%s:%s", "only_one");
        console.log("%s:%s");
    }

    modifier commonOperation() {
        vm.startPrank(Bob);
        // do some common thing
        _;
    }

    function testRevert() public commonOperation {
        // vm.startPrank();
        // vm.expectRevert();

        // // Sets an address' balance.
        // vm.deal(Bob, START_BALANCE);

        // // Sets up a prank from an address that has some ether.
        // hoax(address(3), START_BALANCE);
    }

    // 使用 forge snapshot --mt testNumberIs42 查看消耗多少 Gas,生成文件 .gas-snapshot

    function testGasCost() public {
        // vm.txGasPrice(1);
        // uint256 gasBegin = gasleft();
        // // doSomething
        // console.log("%s:%s", "only_one");
        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasEnd - gasBegin) * tx.gasprice;

        //  console.log("%d", gasUsed);
    }
}
