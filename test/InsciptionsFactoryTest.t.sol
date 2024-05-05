// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {InsciptionsERC20} from "../src/week3/day4/InsciptionsERC20.sol";
import {InsciptionsProxyFactory} from "../src/week3/day4/InsciptionsFactory.sol";

contract InsciptionsFactoryTest is Test {
    address admin = makeAddr("admin");
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    InsciptionsProxyFactory public insciptionsProxyFactory;

    function setUp() public {
        vm.prank(admin);
        insciptionsProxyFactory = new InsciptionsProxyFactory();
    }

    // test deployInscription
    function testDeployInscription_sccuss() public {
        // alice
        vm.startPrank(alice);
        // function deployInscription(string memory _symbol, uint256 _totalSupply, uint256 _perMint, uint256 _price)
        address erc20Addr = insciptionsProxyFactory.deployInscription("MT", 10000, 5, 10);
        InsciptionsProxyFactory.Inscription memory inscription = insciptionsProxyFactory.getInscription(erc20Addr);
        assertEq(inscription.symbol, "MT");
        assertEq(inscription.totalSupply, 10000);
        assertEq(inscription.perMint, 5);
        assertEq(inscription.price, 10);
        vm.stopPrank();
    }

    // 测试 clone 的合约地址不一致
    function testDeployInscription_clone_address_is_not_same() public {
        // alice deploy a inscription
        vm.startPrank(alice);
        // function deployInscription(string memory _symbol, uint256 _totalSupply, uint256 _perMint, uint256 _price)
        address erc20Addr = insciptionsProxyFactory.deployInscription("MT", 10000, 5, 10);
        InsciptionsProxyFactory.Inscription memory inscription = insciptionsProxyFactory.getInscription(erc20Addr);
        vm.stopPrank();

        // bob deploy a new inscription
        vm.startPrank(bob);
        address erc20Addr2 = insciptionsProxyFactory.deployInscription("MT2", 10000, 5, 10);
        assertNotEq(erc20Addr, erc20Addr2);
        vm.stopPrank();
    }

    function testFailed_DeployInscription_param_invalid() public {
        // alice
        vm.startPrank(alice);
        vm.expectRevert("revert: totalSupply must greater than zero");
        address erc20Addr = insciptionsProxyFactory.deployInscription("MT", 0, 5, 10);

        vm.expectRevert("revert: perMint must greater than zero");
        erc20Addr = insciptionsProxyFactory.deployInscription("MT", 10000, 0, 10);

        vm.expectRevert("revert: price must greater than zero");
        erc20Addr = insciptionsProxyFactory.deployInscription("MT", 10000, 10, 0);
        vm.stopPrank();
    }

    // test mintInscription
    function testMintInscription_sccuss() public {
        // alice deploy a inscription
        vm.startPrank(alice);
        address erc20Addr = insciptionsProxyFactory.deployInscription("MT", 100 * 1e18, 5, 10);
        vm.stopPrank();

        // bob execute mint
        vm.deal(bob, 1 ether);
        console.log("bob.balance", bob.balance);
        InsciptionsERC20 erc20 = InsciptionsERC20(erc20Addr);
        vm.startPrank(bob);
        erc20.approve(address(insciptionsProxyFactory), 1 ether);
        console.log("erc20Addr", erc20Addr);
        insciptionsProxyFactory.mintInscription{value: 1 ether}(erc20Addr);
        InsciptionsProxyFactory.Inscription memory inscription = insciptionsProxyFactory.getInscription(erc20Addr);

        assertEq(erc20.balanceOf(bob), 5); // bob mint 数量正确
        assertEq(alice.balance, 45); // alice 扣款正确
        assertEq(address(admin).balance, 5); // 管理员手续费正确
        vm.stopPrank();
    }

    function testMintInscription_fail_when_inscription_not_exist() public {
        // alice
        address invalidUser = address(0);
        vm.startPrank(invalidUser);
        address erc20Addr = insciptionsProxyFactory.deployInscription("MT", 100000, 5, 10);
        InsciptionsProxyFactory.Inscription memory inscription = insciptionsProxyFactory.getInscription(erc20Addr);
        console.log("inscription:", inscription.deployer);
        vm.stopPrank();

        // bob execute mint
        vm.deal(bob, 1 ether);
        vm.startPrank(bob);
        vm.expectRevert("inscription not exist");
        insciptionsProxyFactory.mintInscription{value: 1 ether}(erc20Addr);
        vm.stopPrank();
    }

    function testMintInscription_fail_when_mint_value_not_enough() public {
        // alice
        vm.startPrank(alice);
        address erc20Addr = insciptionsProxyFactory.deployInscription("MT", 10000, 500, 10000000);
        InsciptionsProxyFactory.Inscription memory inscription = insciptionsProxyFactory.getInscription(erc20Addr);
        vm.stopPrank();

        // bob execute mint
        vm.deal(bob, 1 ether);
        vm.startPrank(bob);
        vm.expectRevert("mint value not enough");
         insciptionsProxyFactory.mintInscription{value: 100000}(erc20Addr);
        vm.stopPrank();
    }
}
