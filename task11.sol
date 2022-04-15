/*
Задача №11
Интерфейсы и модификаторы доступа. Написать контракт работающий с другим контрактом с помощью интерфейса. 
*/

// Platform 
// https://ropsten.etherscan.io/address/0x672b6c868C3dA4Ef305175c942073cB46A019179#code
// Verify
// https://ropsten.etherscan.io/address/0xeA6e735a3AF44448E02FE4D53E85da3b467B4920#code

pragma solidity ^0.8.13;

contract Verify {
    bool public verified = true;
    uint public id;

    function counter() external {
        id += 1;
    }
}

interface Patenter {
    function verified() external returns (bool);
    function id() external returns (uint);
    function counter() external;
}

contract Platform {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        msg.sender == owner;
        _;
    }

    mapping(address => Patent) public patents;
    struct Patent {
        uint patentID;
        string namePatent;
        string description;
        uint patentingTime;
        bool verify;
    }

    function PatentRegister(
        string memory name,
        string memory desc,
        address patentAddress
    ) public {

        patents[msg.sender].patentID = Patenter(patentAddress).id(); // получаем ID из другого контракта с помощью интерфейса (по адресу контракта)
        patents[msg.sender].namePatent = name;
        patents[msg.sender].description = desc;
        patents[msg.sender].patentingTime = block.timestamp;

        patents[msg.sender].verify = Patenter(patentAddress).verified(); // получаем переменную из другого контракта

        Patenter(patentAddress).counter(); // задействуем удаленную функцию
    }
}









/*
pragma solidity ^0.8.13;

contract Counter {
    uint public count;

    function increment() external {
        count += 1;
    }
}

interface ICounter {
    function count() external view returns (uint);

    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}


pragma solidity ^0.8.13;

contract Counter1 {
    uint public count;

    function increment() external {
        count += 1;
    }
}

interface ICounter1 {
    function count() external view returns (uint);

    function increment() external;
}

contract MyContract1 {
    address public target = 0xd9145CCE52D386f254917e481eB44e9943F39138;

    function incrementCounter() external {
        ICounter(target).increment();
    }

    function getCount() external view returns (uint) {
        return ICounter(target).count();
    }
}
*/