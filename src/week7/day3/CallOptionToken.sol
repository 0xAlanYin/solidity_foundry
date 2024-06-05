// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

// 设计一个看涨期权 Token（ERC20）：
// 1.创建期权Token 时，确认标的的价格与行权日期；
// 2.发行方法（项目方角色）：根据转入的标的（ETH）发行期权 Token；
// 3.（可选）：可以用期权Token 与 USDT 以一个较低的价格创建交易对，模拟用户购买期权。
// 4.行权方法（用户角色）：在到期日当天，可通过指定的价格兑换出标的资产，并销毁期权Token
// 5.过期销毁（项目方角色）：销毁所有期权Token 赎回标的。

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract CallOptionToken is ERC20, Ownable {
    /**
     * ====================================Events ====================================
     */
    event Deposited(address indexed user, uint256 usdtAmount, uint256 callOptionTokenAmount);
    event Issued(address indexed owner, uint256 amount);
    event Exercised(address indexed user, uint256 usdtAmount, uint256 callOptionTokenAmount);
    event Redeemed(address indexed owner, uint256 amount);

    /**
     * ====================================State Variables ====================================
     */
    uint256 public exercisePrice;

    uint256 public perCallOptionTokenPrice;

    uint256 public exerciseDate;

    uint256 public buyEndDate;

    mapping(address user => uint256 callOptionTokenAmount) public balances;

    uint256 public totalCallOptionTokenAmount;

    IERC20 public usdt;

    /**
     * ====================================Constructor ====================================
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 exercisePrice_, // use USDT to exercise
        uint256 perCallOptionTokenPrice_, // use USDT to buy call option token
        uint256 exerciseDate_,
        uint256 buyEndDate_,
        address initialOwner_,
        address usdt_
    ) ERC20(name_, symbol_) Ownable(initialOwner_) {
        exercisePrice = exercisePrice_;
        perCallOptionTokenPrice = perCallOptionTokenPrice_;
        exerciseDate = exerciseDate_;
        buyEndDate = buyEndDate_;
        usdt = IERC20(usdt_);
    }

    /**
     * ====================================Modifiers ====================================
     */
    modifier onlyBeforeBuyEndDate() {
        require(block.timestamp < buyEndDate, "buy end date passed");
        _;
    }

    modifier onlyAfterBuyEndDate() {
        require(block.timestamp >= buyEndDate, "buy end date not passed");
        _;
    }

    /**
     * ====================================Functions ====================================
     */
    function deposit(uint256 usdtAmount) external onlyBeforeBuyEndDate {
        require(block.timestamp < exerciseDate, "Option expired");
        require(usdtAmount > 0, "amount should be greater than 0");

        uint256 callOptionTokenAmount = usdtAmount / perCallOptionTokenPrice;
        address user = msg.sender;
        balances[user] += callOptionTokenAmount;
        totalCallOptionTokenAmount += callOptionTokenAmount;

        SafeERC20.safeTransferFrom(usdt, user, owner(), usdtAmount);

        emit Deposited(user, usdtAmount, callOptionTokenAmount);
    }

    function issue() external payable onlyOwner onlyAfterBuyEndDate {
        require(block.timestamp < exerciseDate, "Option expired");

        // one callOptionToken mapping to one ETH (1:1)
        uint256 amountCallOptionToken = msg.value;
        require(amountCallOptionToken >= totalCallOptionTokenAmount, "invalid amount");

        _mint(address(this), amountCallOptionToken);

        emit Issued(msg.sender, amountCallOptionToken);
    }

    function exercise(uint256 usdtAmount) external {
        require(block.timestamp >= exerciseDate, "exercise date not reached");

        address user = msg.sender;
        uint256 callOptionTokenAmount = balances[user];
        require(callOptionTokenAmount > 0, "no balance");

        require(usdtAmount == callOptionTokenAmount * exercisePrice, "invalid amount");
        IERC20(usdt).transferFrom(user, owner(), usdtAmount);

        // burn call option token
        _burn(address(this), callOptionTokenAmount);

        // transfer ETH to msg.sender
        Address.sendValue(payable(user), callOptionTokenAmount);

        emit Exercised(user, usdtAmount, callOptionTokenAmount);
    }

    function redeem() external onlyOwner {
        require(block.timestamp >= exerciseDate, "exercise date not reached");

        uint256 remainCallOptionTokenAmount = balanceOf(address(this));
        // burn call option token
        _burn(address(this), remainCallOptionTokenAmount);

        address user = msg.sender;
        // transfer ETH to msg.sender
        Address.sendValue(payable(user), address(this).balance);

        emit Redeemed(msg.sender, remainCallOptionTokenAmount);
    }
}
