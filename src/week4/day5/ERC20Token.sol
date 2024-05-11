// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ERC20Token is ERC20Permit {
    constructor() ERC20("MyToken", "MT") ERC20Permit("MyToken") {}

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
