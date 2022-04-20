/*
Задача №12
Конструкторы и fallback-функции.
Рассмотреть, как они реализованы в разных версиях Solidity - привести примеры и комментарий к каждому примеру. 
Написать простейший контракт с конструктором и fallback-функцией для 7-ой версии
*/


// конструкторы
// 0.5.17

// 0.6.12

// 0.7.6

// 0.8.13


// fallback funcs
// 0.5.17

// 0.6.12

// 0.7.6

// 0.8.13

pragma solidity ^0.7.0;

contract Base {
    uint x;
    constructor(uint _x) { x = _x; }

    function getX() public view returns (uint) {
        return x;
    }
}

// Either directly specify in the inheritance list...
contract Derived1 is Base(7) {
    constructor() {}
}

// or through a "modifier" of the derived constructor.
contract Derived2 is Base {
    constructor(uint _y) Base(_y * _y) {}
}
