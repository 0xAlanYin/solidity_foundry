// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

library SafeMath {
    function add(uint x, uint y) internal view returns (uint) {
        uint z = x + y;
        require(z >= x, "uint overflow");
        return z;
    }
}

contract TestLib {
    using SafeMath for uint;

    function add(uint x, uint y) public returns (uint) {
        return x.add(y);
    }
}
