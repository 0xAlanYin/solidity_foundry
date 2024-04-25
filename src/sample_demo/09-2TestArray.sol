// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract TestArray {
    // 容易理解错误：表示分配一个初始空间，不是代表第一个元素为 1
    uint[] public arr = new uint[](1);

    function addWithoutValue() public {
        // 用来添加新的零初始化元素到数组末尾，并返回元素的引用，以便修改元素的内容，如：x.push().t = 2或x.push() = b，push方法只对存储（storage）中的动态数组有效。
        arr.push();
    }

    function addWithValue(uint x) public {
        // 用来添加给定元素到数组末尾。push(x) 没有返回值，方法只对存储（storage）中的动态数组有效
        arr.push(x);
    }

    function getLen() public view returns (uint) {
        return arr.length;
    }

    function pop() public {
        // 用来从数组末尾删除元素，数组的长度减1，会在移除的元素上隐含调用delete，释放存储空间（及时释放不使用的空间，可以节约gas）。pop()没有返回值，pop()方法只对存储（storage）中的动态数组有效。
        arr.pop();
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

}

contract ArrayGas {
    uint[] numbers;
    uint sum;
    uint currentIndex;

    // 分段计算
    function calculateSum(uint endIndex) public {
        if(endIndex > currentIndex) {
            for (uint256 i = currentIndex; i < endIndex; i++) {
                sum += numbers[i];
            }
        }
    }

    // 推荐数组移除元素的实现
    function remove(uint index) public {
        uint len = numbers.length;
        if (index == len - 1) {
            numbers.pop();
        } else {
            // 被删除元素与最后一个元素交换位置
            numbers[index] = numbers[len -1];
            numbers.pop();
        }
    }
}

contract TestStringBytes {
    bytes bs;
    bytes bs0 = "12abcd";
    bytes bs1 = "abc\x22\x22";   // 十六进制数
    bytes bs2 = "Alan\u661f";   //u661f为汉字“星”的Unicode编码值

    string str = "AlanYin";
    
    string name;

    function setName(string calldata _name) public {
        name = _name;
    }
}
