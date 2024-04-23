import {Test, console} from "forge-std/Test.sol";

import {MyToken} from "../src/week2/MyToken.sol";
import {TokenBank} from "../src/week2/TokenBankV2.sol";

contract MyTokenTest is Test {
    MyToken public token;
    TokenBank public tokenBank;

    address public bob = address(1);

    function setUp() public {
        token = new MyToken();
        tokenBank = new TokenBank(address(token));
        token.transfer(bob, 100 ether);
    }

    function testTransferCallback() public {
        token.transfer(address(tokenBank),  1 ether);
    }
}
