// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// 映射
// • 声明形式： mapping(KeyType => ValueType) ， 例如：mapping(address => uint) public balances;
// • 使⽤⽅式类似数组，通过 key 访问，例如： balances[userAddr];
// • 映射没有⻓度、没有 key 的集合或 value 的集合的概念
// • 只能作为状态变量（storage）
// • 如果访问⼀个不存在的键，返回的是默认值。
contract TestMapping {
    mapping(address => uint256) public balances;

    function update(uint256 amount) public {
        balances[msg.sender] = amount;
    }

    function get(address addr) public view returns (uint256) {
        return balances[addr];
    }

    // 映射可以嵌套
    mapping(address => mapping(address => uint256)) testMapping;

    function init(uint256 newBalance) public {
        // mapping(address => uint) memory balances;   // 错误， mapping 不可以为 memory,只能作为状态变量
    }
}

// 不过这种实现的可迭代映射， Gas 成本较高，还有另一个方式是使用 mapping 来实现一个链表，用链表来保存下一个元素来进行迭代（我比较推荐的实现）
contract Iterable1 {
    mapping(address => uint256) balances;
    address[] users;

    function length() public view returns (uint256) {
        return users.length;
    }

    function insert(address user, uint256 amount) public {
        balances[user] = amount;
        users.push(user);
    }
}

contract Iterable2 {
    mapping(address => uint256) balances;
    mapping(address => address) nextUser;

    address constant GUARD = address(1);

    // 保存长度
    uint256 public length;

    function insert(address user, uint256 amount) public {
        balances[user] = amount;

        nextUser[user] = nextUser[GUARD];
        nextUser[GUARD] = user;
        length++;
    }
}
