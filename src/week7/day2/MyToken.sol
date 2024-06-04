// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

// 1.先实现一个可以可计票的 Token
// 2.实现一个通过 DAO 管理Bank的资金使用：
// - Bank合约中有提取资金withdraw()，该方法仅管理员可调用。
// - 治理 Gov 合约作为 Bank 管理员, Gov 合约使用 Token 投票来执行响应的动作。
// - 通过发起提案从Bank合约资金，实现管理Bank的资金。

// 使用 OpenZeppelin 实现一个可以可计票的 Token
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "@openzeppelin/contracts/utils/Nonces.sol";

contract MyToken is ERC20, ERC20Permit, ERC20Votes {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        _mint(msg.sender, 1e8 * 10 ** decimals());
    }

    // The functions below are overrides required by Solidity.

    function _update(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._update(from, to, amount);
    }

    function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }
}
