// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface ITokenReceiver {
    function tokenReceived(
        address recipient,
        uint256 amount,
        bytes memory extraData
    ) external returns (bool);
}

contract MyToken is ERC20 {
    constructor() ERC20("MyERC20", "BERC20") {
        _mint(msg.sender, 100000000 * 10 ** 18);
    }

    // 扩展 ERC20 合约，使其具备在转账的时候，如果目标地址是合约的话，调用目标地址的 tokensReceived() 方法
    function transferWithCallback(address recipient, uint256 amount, bytes memory extraData) public returns(bool) {
        _transfer(msg.sender, recipient, amount);
        // 如果是合约，则调用tokenReceived
        if (isContract(recipient)) {
            bool success = ITokenReceiver(recipient).tokenReceived(
                msg.sender,
                amount,
                extraData
            );
            require(success, "No token received");
        }
        return true;
    }

    function isContract(address addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return (size > 0);
    }
}
