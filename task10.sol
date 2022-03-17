pragma solidity ^0.8.12;

contract Test {
    
    uint public value;
    
    function testFor() public {
        uint counter;
        for (uint i = 0; i < value; i++) {
            counter += value;
        }
    }

    function testWhile() public {
        uint i;
        while (i != value) {
            uint counter;
            counter += value;
            i++;
        }
    }
}
