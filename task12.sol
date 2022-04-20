/*
Задача №12
Конструкторы и fallback-функции.
Рассмотреть, как они реализованы в разных версиях Solidity - привести примеры и комментарий к каждому примеру. 
Написать простейший контракт с конструктором и fallback-функцией для 7-ой версии
*/

// конструкторы
// constructor() - необязательная функция для контракта, которая выполняется один раз при его создании
// до версии 0.4.22 функция конструктора должна была иметь название контракта
// с 0.5 просто constructor(), также конструктор должен иметь идентификатор public
// 0.5.17
contract MyContract1 {
    address owner;
    constructor() public { // конструктор может не принимать параметров
        owner = msg.sender; // но может присвоить значение переменным при создании контракта
    }
}

contract MyContract2 is MyContract1 {
    address public creator;
    uint public value;
    constructor(uint _value) public MyContract1() { // пример в котором конструктор принимает параметры
        value = _value;
        creator = owner;
    }

    function getValue() public view returns (uint) {
        return value;
    }

    function getOwner() public view returns (address) {
        return creator;
    }
}

contract MyContract3 is MyContract1, MyContract2 {
    constructor() public MyContract1() MyContract2() {} // также можно использовать конструктор при наследовании
    // при создании MyContract3 будет вызван конструктор контракта MyContract1
    // (необходимо, чтобы конструктор имел идентификатор видимости: public)
    // когда мы используем несколько конструкторов -> порядок выполнения: MyContract1, MyContract2, MyContract3
    // т.е сначала по очереди выполняются конструкторы из вне, после выполняется конструктор контракта
    function getOwner() public view returns (address) {
        return owner;
    }

    function getValue() public view returns (uint) {
        return value;
    }
}
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
