/*
Задача №12
Конструкторы и fallback-функции.
Рассмотреть, как они реализованы в разных версиях Solidity - привести примеры и комментарий к каждому примеру. 
Написать простейший контракт с конструктором и fallback-функцией для 7-ой версии
*/

// контракт для 7ой версии - с 138 строки

// конструкторы
// constructor() - необязательная функция для контракта, которая выполняется один раз при его создании
// до версии 0.4.22 функция конструктора должна была иметь название контракта
// с 0.5 просто constructor(), также конструктор должен иметь идентификатор public или internal
// если internal - то он становится абстрактным

// 0.5.17
// pragma solidity ^0.5.17;

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
// реализация констукторов такая же

// 0.7.6
// обязательный идентификатор видимости больше не нужен
// очередность вызова внешних конструкторов такая же
// pragma solidity ^0.7.6;

contract Base {
    uint value;
    constructor(uint _val) { value = _val; }
}

// 0.8.13
// pragma solidity ^0.8.13;

contract ContractA {
    constructor() {}
}

contract ContractB {
    constructor() {}
}

contract ContractC is ContractB, ContractA {
    constructor() ContractB() ContractA() {}
    // очередность вызова конструкторов зависит от последовательности указанной при наследовании
    // B -> A -> C
}

contract ContractD is ContractB, ContractA { // 2. завимость в этой последовательности
    constructor() ContractA() ContractB() {} // 1. здесь нет зависимости в какой последовательности указаны конструкторы
    // B -> A -> C
}



// fallback funcs
// 0.3.6
contract Contract3 {
    function() {  }
    // для исключения случайной отправки эфира на контракт должна быть одна пустая функция,
    // которая отклонит перевод средств за минимальное количество газа - 2300 gas
}

// 0.4.26
contract Contract4 {
    fallback() payable;
    // если не указывать функцию fallback, она будет работать по умолчанию, вызывая исключение
    // при отправке эфира, также функция fallback вызовется, если будут запрошены несуществующие функции контракта
    // для возможности отправки эфира на контракт нужен идентификатор *payable*
}

// 0.5.17
    // в версия 0.5.0 изменений fallback нет

// 0.6.12
    // контракт может иметь не более одной резервной функции
contract Contract6 {
    uint x;
    fallback() external payable { x = msg.value; }
    // с 0.6 версии fallback функция долнжна иметь идентификатор видимости - external
    // все также она служит для исключения вызовов несоответствующих функций
    // а чтобы получать на контракт эфир нужно указывать *payable*
    // также на ряду с fallback() payable необходимо использовать receive() функцию для избежания путаницы
    // с 0.4.0 версий можно работать с msg.data приходящих транзакций
}

// 0.7.6
contract Contract7 {
    fallback(bytes calldata _input) external returns (bytes memory _output);
    // с 0.7.0 версий fallback функция также может быть виртуальной и иметь модификаторы
    // с помощью _input мы можем получить информацию из msg.data, далее она вернется в _output
    // и с этой информаций можно продолжать работу
}

// 0.8.13
    // в 8 версиях используются параметры input и output
    // работа конструктора осталась прежней


pragma solidity ^0.7.6;

contract TaskContract {
    uint x;

    receive() external payable {} // функция для получения эфира
    fallback() external {} // функция для исключения вызовов несуществующих функций

    constructor(uint _customValue) { x = _customValue; }
    // конструктор при создании контракта запишет в X указанное значение

    function getX() public view returns (uint) {
        return x;
    }
}
