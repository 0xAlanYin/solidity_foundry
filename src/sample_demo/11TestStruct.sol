// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract TestStruct {
    struct Funder {
        address addr;
        uint256 amount;
    }

    mapping(uint256 => Funder) funders;

    function contribute(uint256 id) public payable {
        funders[id] = Funder({addr: msg.sender, amount: msg.value});
        funders[id] = Funder(msg.sender, msg.value);
    }

    function getFunder(uint256 id) public view returns (address, uint256) {
        return (funders[id].addr, funders[id].amount);
    }
}

contract TestStruct2 {
    struct Student {
        string name;
        uint8 age;
        mapping(string => uint) scores;
        // Student child; // 错误的写法，不能引用自身
    }

    struct School {
        Student[] students;
        mapping(uint => Student) numbers;
    }

    // 2.结构体变量声明与赋值
    // 2.1 仅声明变量而不赋值，此时会使用默认值创建结构体变量
    struct Person {
        address account;
        string name;
        uint8 age;
    }

    Person person1;

    // 2.2 按成员顺序（结构体声明时的顺序）赋值
    Person person2 = Person(address(0x0), "zhangsan", 18);

    function name() public pure returns (Person memory) {
        Person memory person3 = Person(address(0x0), "zhangsan", 18);
        return person3;
    }

    // 2.3 具名方式赋值
    Person person4 = Person({account: address(0x0), name: "zhangsan", age: 18});

    function name2() public pure returns (Person memory) {
        Person memory person5 = Person({
            account: address(0x0),
            name: "zhangsan",
            age: 18
        });
        return person5;
    }

    Person person6;
    // 2.4 以更新成员变量的方式给结构体变量赋值
    function updatePerson() public {
        person6.account = msg.sender;
        person6.age = 18;
        person6.name = "zhangsan";
    }
}
