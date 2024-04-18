pragma solidity >0.8.0;

contract TestAddress {
    function testTransfer(address payable x) public {
        // 合约转换为地址类型
        address myAdress = address(this);
        if (myAdress.balance >= 10) {
            // 调⽤ x 的transfer ⽅法: 向 x 转10 wei
            x.transfer(10);
        }
    }
}
