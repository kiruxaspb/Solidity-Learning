/*
Задача №15
Выполнение конструкторов сразу в нескольких контрактах.
Написать пример, когда при установке главного контракта в связанном контракте
выполняется конструктор с параметрами из главного контракта
*/

// MyContract1
// https://ropsten.etherscan.io/address/0x5bF5C865d11ae3b4E164DC61718bec16BDe652D7#code

// MyContract2
// https://ropsten.etherscan.io/address/0xb352732f32867fBad42d76Dda276A76235891DdB#code

// MyContract3
// https://ropsten.etherscan.io/address/0x009aB693458841370337cFa7A4E33d8E15B0437D#code

pragma solidity ^0.8.13;

contract MyContract1 {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function getContractOnwer() public view returns (address) {
        return owner;
    }
}


contract MyContract2 is MyContract1 {
    address public creator;
    string public name;

    constructor(string memory _name) {
        name = _name;
        creator = msg.sender;
    }

    function getOwnerName() public view returns (string memory) {
        return name;
    }

    function getOwner2() public view returns (address) {
        return owner;
    }
}


contract MyContract3 is MyContract1, MyContract2 {
    string public testname;
    address public creator3;
    
    constructor() MyContract1() MyContract2("Kirill") {
        testname = name;
        creator3 = creator;
    }
    function getOwner3() public view returns (address) {
        return creator3;
    }

    function getOwnerName3() public view returns (string memory) {
        return testname;
    }
}