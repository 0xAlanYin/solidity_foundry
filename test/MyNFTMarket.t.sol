// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {MyToken} from "../src/week2/MyToken.sol";
import {MyERC721} from "../src/week2/MyERC721.sol";
import {MyNFTMarket} from "../src/week2/MyNFTMarket.sol";

contract MyNFTMarketTest is Test {
    MyNFTMarket public myNFTMarket;
    MyToken public myToken;
    MyERC721 public myERC721;

    address public bob =address(1);

    function setUp() public {
        myToken = new MyToken();
        myERC721 = new MyERC721();
        myNFTMarket = new MyNFTMarket(address(myToken) , address(myERC721));
        myERC721.mint(address(this), "xxx");
        myToken.transfer(bob, 100 ether);
    }

    function test_list() public {
          myERC721.approve(address(myNFTMarket), 1);
          myNFTMarket.list(1, 1 ether);
          
          vm.startPrank(bob);
          myToken.approve(address(myNFTMarket), 100 ether);
          myNFTMarket.buyNFT(1);
          vm.stopPrank();
    }

}