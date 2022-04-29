/*
Задача №15
Выполнение конструкторов сразу в нескольких контрактах.
Написать пример, когда при установке главного контракта в связанном контракте
выполняется конструктор с параметрами из главного контракта
*/
pragma solidity ^0.8.13;

contract MyContract1 {
    address owner;
    constructor() {
        owner = msg.sender;
    }
}

contract MyContract2 is MyContract1 {
    address public creator;
    uint public value;
    constructor(uint _value) {
        value = _value;
        creator = owner;
    }

    function getValue2() public view returns (uint) {
        return value;
    }

    function getOwner2() public view returns (address) {
        return creator;
    }
}

contract MyContract3 is MyContract1, MyContract2 {
    uint test;
    address creator3;
    constructor() MyContract1() MyContract2(22) {
        test = value;
        creator3 = owner;
    }
    function getOwner3() public view returns (address) {
        return creator3;
    }

    function getValue3() public view returns (uint) {
        return test;
    }
}
