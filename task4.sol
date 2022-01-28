/*
Задача №4:
Работа с несколькими контрактами. Интерфейсы. Реализовать логику таким образом,
чтобы функции из одного контракта были доступны для другого контракта.
Но необходимо ограничить доступ к функциям первого контракта так,
чтобы их мог вызывать только второй контракт.
*/

// Реализация с помощью наследования:
// https://ropsten.etherscan.io/address/0x8f38A2252C9435035970B2149B98074d9f987B7A#code

// Реализация с помощью адреса контракта:
// СontractOne: https://ropsten.etherscan.io/address/0x64110149765CF53Ee09678Fb81987588f6381324#code
// ContractTwo: https://ropsten.etherscan.io/address/0x376F0debdffC7F64ed9AD14A58EC7BD5af624A4f#code

// Работа с интерфейсами:
// Counter: https://ropsten.etherscan.io/address/0x443898c58640C34Cf7C58bAE59383C3A9257BdE7#code
// TestInterface: https://ropsten.etherscan.io/address/0x5D3f34C8bE7b4aed9CCDC150c3de9d55883f1d60#code


pragma solidity ^0.8.11;

// реализация доступа к функциям Contract1 только из Contract2 с помощью наследования
// в этом случае не сможем вызвать function1 или function2 из других контрактов без наследования
// указатель internal ограничивает вызов функций в Contract1 где они инициализированы
// он позволяет нам вызывать такие функции в наследованных контрактах
contract Contract1 {
    function function1(uint8 _x, uint8 _y) internal pure returns(uint, string memory) {
        return(_x + _y - 5, "Result from function1 Contract1");
    }

    function function2(string memory _name) internal pure returns(string memory, string memory) {
        string memory name = _name;
        return(name, "Result from function2 Contract1");
    }
}

contract Contract2 is Contract1 {
    function function3(uint8 _x, uint8 _y) public pure returns (uint, string memory){
        return (function1(_x, _y));
    }
    
    function function4(string memory _name) public pure returns (string memory, string memory) {
        return (function2(_name));
    }
}

// реализация доступа к функции из ContractOne из контракта ContractTwo с помощью адреса контакта и ограничения доступа
pragma solidity ^0.8.11;

contract ContractOne {
    mapping(address => bool) public AccessList; // создаем сопоставление адреса контракта и булевой переменной для "ограничения доступа"

    function addAccess(address _addressContract) public { // функция предоставление доступа, получает адрес контракта
        AccessList[_addressContract] = true; // разрешаем контакту доступ, присваем адресу "true"
    }

    // функция, которую вызываем из ContractTwo
    function callFunction(address _addr, uint8 _value1, uint8 _value2) public view returns(uint, string memory) {
        require(AccessList[_addr] == true, "Access denied"); // если введенный адрес не true, получаем ошибку
        return(_value1 * _value2, "Access received"); // выполнение функции
    }
}

contract ContractTwo {
    // функция запроса доступа для контакта, вводим адрес ContractOne и ContractTwo для получения доступа к функциям
    function callAccess(address _contractOneAddress, address _addressThisContract) public {
        ContractOne contract1 = ContractOne(_contractOneAddress); // создамем интерфейс использования функции из ContractOne
        contract1.addAccess(_addressThisContract); // вводим адрес ContractTwo для получения доступа
    }
    // функция тестирования вызова из ContractOne с условием валидного доступа
    // вводим адрес ContractOne, ContractTwo и наши переменные
    function test(address _addressContractOne, address _addThisContract, uint8 _x, uint8 _y) public view returns(uint, string memory) {
        ContractOne contract1 = ContractOne(_addressContractOne); // создаем интерфейс
        return (contract1.callFunction(_addThisContract, _x, _y)); // вызываем функцию
    }
}


// интерфейс - это абстрактный контакт, который имеет в себе некоторые функциональные ограничения
// не могут быть реализованы какие либо функции
// все существующие функции должны быть extrenal
// может иметь наследование от других интерфейсов
// контракты могут наследовать интерфейсы
// не может иметь в себе конструктор
// не может хранить переменные
// не может иметь модификаторы

pragma solidity ^0.8.11;

contract Counter {
    uint public count;

    function add() external { // внешняя функция, чтобы можно было вызвать из другого контракта
        count += 1;
    }
}

// с помощью интефейса мы можем обратиться к функциям контракта не зная код контракта
// выполнение функций будет происходить на стороне контракта, а с помощью интерейса
// можно вызвать эти функции или получить значения из контракта
interface MyCounter {
    function count() external view returns (uint); // получаем значение счетчика

    function add() external; // вызываем функцию счетчика
}

// получаем функции контакта Counter с помощью интерфейса MyCounter
contract TestInterface {
    function useCountAdd(address _counterAddress) public { // вводим адрес контракта
        MyCounter(_counterAddress).add(); // с помощью интерфейса вызываем функцию прибавления
    }

    function getValueCount(address _counterAddress) public view returns (uint) {
        return MyCounter(_counterAddress).count(); // с помощью интерфейса получаем значение из контракта
    }
}

