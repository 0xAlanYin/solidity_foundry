// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        require(z >= x, "uint overflow");
        return z;
    }
}

contract TestLib {
    using SafeMath for uint;

    function add(uint x, uint y) public pure returns (uint) {
        return x.add(y);
    }
}
