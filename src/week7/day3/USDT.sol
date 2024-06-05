// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

// implement USDT
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract USDT is ERC20, Ownable {
    constructor(string memory name_, string memory symbol_, address initialOwner_)
        ERC20(name_, symbol_)
        Ownable(initialOwner_)
    {
        _mint(initialOwner_, 1e18);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
