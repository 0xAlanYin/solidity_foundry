// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 完善合约，实现以下功能：

// - 设置 Token 名称（name）："BaseERC20"
// - 设置 Token 符号（symbol）："BERC20"
// - 设置 Token 小数位decimals：18
// - 设置 Token 总量（totalSupply）:100,000,000
// - 允许任何人查看任何地址的 Token 余额（balanceOf）
// - 允许 Token 的所有者将他们的 Token 发送给任何人（transfer）；转帐超出余额时抛出异常(require),并显示错误消息 “ERC20: transfer amount exceeds balance”。
// - 允许 Token 的所有者批准某个地址消费他们的一部分Token（approve）
// - 允许任何人查看一个地址可以从其它账户中转账的代币数量（allowance）
// - 允许被授权的地址消费他们被授权的 Token 数量（transferFrom）；
// 转帐超出余额时抛出异常(require)，异常信息：“ERC20: transfer amount exceeds balance”
// 转帐超出授权数量时抛出异常(require)，异常消息：“ERC20: transfer amount exceeds allowance”。
contract BaseERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor() {
        // set name,symbol,decimals,totalSupply
        name = "BaseERC20";
        symbol = "BERC20";
        decimals = 18;
        totalSupply = 100000000 * 10 ** 18;
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        address owner = msg.sender;

        _transfer(owner, _to, _value);

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // get spender
        address _spender = msg.sender;
       
        // update spender allowance
        _updateSpenderAllowance(_from, _spender, _value);

        // update origin owner 's balance
        _transfer(_from, _to, _value);

        emit Transfer(_from, _to, _value);
        return true;
    }

    function _updateSpenderAllowance(address owner, address spender, uint256 value) internal {
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= value, "ERC20: transfer amount exceeds allowance");

        _approve(owner, spender, currentAllowance - value);
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        address _owner = msg.sender;
        _approve(_owner,_spender, _value);

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function _approve(address owner, address spender,uint256 value) internal {
        allowances[owner][spender] = value;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        // 允许任何人查看一个地址可以从其它账户中转账的代币数量（allowance）
        return allowances[_owner][_spender];
    }

    function _transfer(address from, address to, uint256 value) internal {
        uint256 amount = balances[from];
        require(amount >= value, "ERC20: transfer amount exceeds balance");
        
        if (from == address(0)) {
            // 如果是零地址，总供应量增加
            totalSupply += value;
        } else {
            uint256 fromBalance = balances[from];
            require(fromBalance >= value, "ERC20: transfer amount exceeds balance");
            balances[from] -= value;
        }

        if (to == address(0)) {
            // 如果是零地址，总供应量减少
            totalSupply -= value;
        } else {
            balances[to] += value;
        }
    }
}
