// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        require(z >= x, "uint overflow");
        return z;
    }
}

contract TestLib {
    using SafeMath for uint256;

    function add(uint256 x, uint256 y) public pure returns (uint256) {
        return x.add(y);
    }
}
