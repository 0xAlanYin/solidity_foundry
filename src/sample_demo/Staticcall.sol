pragma solidity ^0.8.0;

contract ContractA {
    uint256 private value;

    constructor(uint256 _value) {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}

contract ContractB {
    function callGetValue(address contractA) public view returns (uint256) {
        (bool success, bytes memory result) = contractA.staticcall(abi.encodeWithSignature("getValue"));
        require(success);

        uint256 data = abi.decode(result, (uint256));
        return data;
    }
}
