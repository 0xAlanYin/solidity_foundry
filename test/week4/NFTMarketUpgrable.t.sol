// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {MyToken} from "../../src/week4/day1/MyToken.sol";
import {MyERC721} from "../../src/week4/day1/MyERC721.sol";
import {NFTMarket} from "../../src/week4/day1/NFTMarketUpgrable.sol";
import {NFTMarketV2} from "../../src/week4/day1/NFTMarketUpgrableV2.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {Options} from "openzeppelin-foundry-upgrades/Options.sol";

contract NFTMarketUpgrableTest is Test {
    MyToken public erc20Token;
    MyERC721 public erc721Token;
    NFTMarket public nftMarket;

    ERC1967Proxy public proxy;

    address public owner;
    address public uprageOwner;

    address public bob = address(3);
    address public cindy = address(4);

    function setUp() public {
        erc20Token = new MyToken();
        erc721Token = new MyERC721();

        // 定义部署 owner
        owner = address(this);
        // 部署实现
        NFTMarket implementation = new NFTMarket();

        // Deploy the proxy and initialize the contract through the proxy
        console.log("address(this):", address(this));
        console.log("address(owner):", address(owner));

        proxy = new ERC1967Proxy(
            address(implementation),
            abi.encodeWithSelector(NFTMarket.initialize.selector, owner, address(erc20Token), address(erc721Token))
        );
        console.log("proxy:", address(proxy));
        // 用代理关联 NFTMarket 接口
        nftMarket = NFTMarket(address(proxy));

        // 定义一个新的 owner 用于升级测试
        uprageOwner = address(2);

        // Emit the owner address for debugging purposes
        emit log_address(owner);

        erc721Token.mint(bob, "0xMockIPFSLink");
    }

    // test list
    function testList_success() public {
        uint256 tokenId = 1;
        erc20Token.transfer(bob, 1000);

        vm.startPrank(bob);
        erc721Token.isApprovedForAll(bob, address(nftMarket));
        erc721Token.approve(address(nftMarket), tokenId);
        nftMarket.list(1, 100);
        vm.stopPrank();

        // 价格匹配
        uint256 gotPrice = nftMarket.tokenIdPrice(tokenId);
        assertEq(100, gotPrice, "want 100,but failed ");

        // 卖家匹配
        address seller = nftMarket.tokenSeller(tokenId);
        assertEq(bob, seller, "want bob failed ");
        vm.stopPrank();
    }

    // forge test --mt testUpgradeV1 --ffi
    // test upgrade
    function testUpgradeV1() public {
        console.log("msg.sender is:", msg.sender);
        console.log("address(this) is:", address(this));
        console.log("owner is:", address(this));
        // Options memory opts;
        // opts.unsafeSkipAllChecks = true;
        // Upgrade the proxy to a new version; NFTMarketV2
        Upgrades.upgradeProxy(address(proxy), "NFTMarketUpgrableV2.sol:NFTMarketV2", "", owner);

        console.log("version:", NFTMarketV2(address(proxy)).version());
    }
}
