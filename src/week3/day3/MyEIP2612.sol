// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyEIP2612 is ERC20Permit {
    constructor() ERC20("MyEIP261", "MyE") ERC20Permit("MyEIP261") {
        _mint(msg.sender, 1e18);
    }
}
