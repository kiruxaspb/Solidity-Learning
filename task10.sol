pragma solidity ^0.8.13;

contract Test {
    uint public value;
    
    function testFor(uint _value) public {
        uint counter;
        value = _value;
        for (uint i = 0; i < value; i++) {
            counter += value;
        }
    }

    function testWhile(uint _value) public {
        uint i;
        i = _value;
        while (i != value) {
            uint counter;
            counter += value;
            i++;
        }
    }
}
