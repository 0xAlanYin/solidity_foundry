// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyERC20Permit is ERC20Permit {
    constructor() ERC20("MyEIP261", "MyE") ERC20Permit("MyEIP261") {}

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
