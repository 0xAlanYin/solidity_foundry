// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

abstract contract A {
    uint public a;
    function add(uint x) public virtual;
}

contract B is A {
    uint public b;

    constructor() {
        b = 1;
    }

    function add(uint x) public virtual override {
        b += x;
    }
}

contract C is B {
    function add(uint x) public override {
        super.add(x);
    }
}
