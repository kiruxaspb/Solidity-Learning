/*
Задача №11
Интерфейсы и модификаторы доступа. Написать контракт работающий с другим контрактом с помощью интерфейса. 
*/

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