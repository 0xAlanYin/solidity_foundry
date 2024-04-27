// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";

import {MyToken} from "../src/week2/MyToken.sol";
import {MyERC721} from "../src/week2/MyERC721.sol";
import {MyNFTMarket} from "../src/week2/MyNFTMarket.sol";
import "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract MyNFTMarketTest is Test {
    MyNFTMarket public myNFTMarket;
    MyToken public myToken;
    MyERC721 public myERC721;

    address public bob = address(1);

    address public cindy = address(2);

    function setUp() public {
        myToken = new MyToken();
        myERC721 = new MyERC721();
        myNFTMarket = new MyNFTMarket(address(myToken), address(myERC721));
        myERC721.mint(bob, "0xMockIPFSLink");
    }

    // 卖家成功上架
    function testList_success() public {
        uint256 tokenId = 1;
        _list(tokenId, bob, myNFTMarket);

        // 价格匹配
        uint256 gotPrice = myNFTMarket.tokenId2Price(tokenId);
        assertEq(100, gotPrice, "want 100,but failed ");

        // 卖家匹配
        address seller = myNFTMarket.tokenId2Seller(tokenId);
        assertEq(bob, seller, "want bob failed ");
        vm.stopPrank();
    }

    // 非卖家本人不能上架
    function testList_failed_when_not_owner_operation() public {
        uint256 tokenId = 1;
        myToken.transfer(cindy, 1000);

        vm.startPrank(cindy);
        vm.expectRevert("not owner");
        myNFTMarket.list(1, 100);
        vm.stopPrank();
    }

    // 别人成功购买NFT
    function testBuyNFT_success() public {
        // bob 上架
        uint256 tokenId = 1;
        _list(tokenId, bob, myNFTMarket);

        // cindy 授权后成功购买
        myToken.transfer(cindy, 1000);
        vm.startPrank(cindy);
        myToken.approve(address(myNFTMarket), 1000);
        myNFTMarket.buyNFT(tokenId);
        assertEq(myERC721.ownerOf(tokenId), cindy, "owner is not cindy");
        vm.stopPrank();
    }

    // 本人成功购买NFT
    function testBuyNFT_success_by_self() public {
        // bob 上架
        uint256 tokenId = 1;
        _list(tokenId, bob, myNFTMarket);

        // cindy 授权后成功购买
        myToken.transfer(bob, 1000);
        vm.startPrank(bob);
        myToken.approve(address(myNFTMarket), 1000);
        myNFTMarket.buyNFT(tokenId);
        assertEq(myERC721.ownerOf(tokenId), bob, "owner is not bob");
        vm.stopPrank();
    }

    function _list(uint256 tokenId, address seller, MyNFTMarket _myNFTMarket) internal {
        uint256 tokenId = 1;
        myToken.transfer(seller, 1000);

        vm.startPrank(seller);
        myERC721.isApprovedForAll(seller, address(_myNFTMarket));
        myERC721.approve(address(_myNFTMarket), tokenId);

        _myNFTMarket.list(1, 100);

        vm.stopPrank();
    }

    // 授权的token余额不足时购买失败
    function testBuyNFT_faild_when_allow_token_not_enough() public {
        uint256 tokenId = 1;
        _list(tokenId, bob, myNFTMarket);

        myToken.transfer(cindy, 1000);
        vm.startPrank(cindy);
        // 仅授权 1 token,但售价 需要 1000 token
        myToken.approve(address(myNFTMarket), 1);
        vm.expectRevert(
            abi.encodeWithSignature("ERC20InsufficientAllowance(address,uint256,uint256)", address(myNFTMarket), 1, 100)
        );
        // 下面效果等同
        // vm.expectRevert(
        //     abi.encodeWithSelector(IERC20Errors.ERC20InsufficientAllowance.selector, address(myNFTMarket), 1, 100)
        // );

        myNFTMarket.buyNFT(tokenId);
        vm.stopPrank();
    }

    // 卖家没有授权市场时购买失败
    function testBuyNFT_faild_when_seller_not_approve_market_sell() public {
        uint256 tokenId = 1;
        // 这里没有使用 _list 函数，卖家未对市场授权
        myToken.transfer(bob, 1000);

        vm.startPrank(bob);
        myNFTMarket.list(1, 100);
        vm.stopPrank();

        myToken.transfer(cindy, 1000);
        vm.startPrank(cindy);
        myToken.approve(address(myNFTMarket), 1000);
        vm.expectRevert(
            abi.encodeWithSignature("ERC721InsufficientApproval(address,uint256)", address(myNFTMarket), tokenId)
        );
        myNFTMarket.buyNFT(tokenId);
        vm.stopPrank();
    }

    // 回调购买成功
    function testTransferCallback_market_buy_nft_success() public {
        uint256 tokenId = 1;
        _list(tokenId, bob, myNFTMarket);

        myToken.transfer(cindy, 100);
        vm.startPrank(cindy);
        bytes memory data = abi.encode(tokenId);
        bool success = myToken.transferWithCallback(address(myNFTMarket), 100, data);
        assertEq(true, success);
        vm.stopPrank();
    }

    // 回调购买失败
    function testTransferCallback_market_buy_nft_failed() public {
        uint256 tokenId = 1;
        _list(tokenId, bob, myNFTMarket);

        myToken.transfer(cindy, 10);
        vm.startPrank(cindy);
        vm.expectRevert(abi.encodeWithSignature("ERC20InsufficientBalance(address,uint256,uint256)", address(cindy), 10, 100));
        bytes memory data = abi.encode(tokenId);
        myToken.transferWithCallback(address(myNFTMarket), 100, data);
        vm.stopPrank();
    }
}
