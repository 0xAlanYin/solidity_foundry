// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// Try Catch
// • try/catch: 捕获合约中外部调⽤的异常
// • 即便是不存在的函数调⽤也可以捕获
// • 合约不存在则⽆法捕获
// • 注意：out of gas 错误不是程序异常，错误不能捕获。

interface IFoo {
    function myFunc1(uint x) external pure returns (uint);
    function myFunc2(uint x) external pure returns (uint);
}

contract Foo {

    error NotZero();

    function myFunc1(uint x) public pure returns (uint) {
        // require(x > 0, "x must gt 0");
        if ( x == 0) revert NotZero();

        return x + 1;
    }
}

contract TestTryCatch {

    IFoo public foo;
    uint public x;

    string public errString;
    bytes public errBytes;

    constructor (address _foo) {
        foo = IFoo(_foo);
    }

    function TryCatchExternalCall(uint _i) public {
        foo.myFunc1(_i);
        
        try foo.myFunc2(_i) returns (uint result) {
            x = result;
        } catch Error(string memory reason) { //  catch revert 
            errString = reason;
        } catch (bytes memory reason) {
            errBytes = reason;
        }
    }
}
