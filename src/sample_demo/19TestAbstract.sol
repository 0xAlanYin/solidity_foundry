// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

abstract contract A {
    uint256 public a;

    function add(uint256 x) public virtual;
}

contract B is A {
    uint256 public b;

    constructor() {
        b = 1;
    }

    function add(uint256 x) public virtual override {
        b += x;
    }
}

contract C is B {
    function add(uint256 x) public override {
        super.add(x);
    }
}
