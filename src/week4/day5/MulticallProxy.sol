// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract Proxy {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    // 实现 multicall
    function multicall(bytes[] calldata data) external virtual returns (bytes[] memory) {
        bytes[] memory results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(target).delegatecall(data[i]);
            results[i] = result;
            require(success, "AirdopMerkleNFTMarket: multicall failed");
        }
        return results;
    }
}
