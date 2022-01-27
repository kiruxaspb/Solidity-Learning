/* 
Задача №3:
Работа с mapping. Написать контракт для добавления и удаления элементов.
Пусть будет привязанный к адресу кошелька тип депозита,
который можно или нельзя использовать этому пользователю
*/

// https://ropsten.etherscan.io/address/0x00e1329967436F4C5D3C0073d614EEBE94BE764b#code

pragma solidity ^0.8.11;

contract Deposits {
    address public contributor; // создаем адресную переменную, для пользователя контракта

    constructor() { // конструктор вызывается 1 раз при вызове контракта
        contributor = msg.sender; // задаем пользователя контракта
    }

    modifier onlyContributor() { // модификатор позволяющий работать только со своими депозитами
        require(msg.sender == contributor, "Access denied!"); // предотвращаем доступ к чужим депозитами
        _; // указывает, что дальше в функции выполняется код если require возращает true
    }

    modifier checkType(uint8 _type) { // модификатор для проверки типа депозита
        require(_type <= 2, "Incorrect deposit type!"); // если будет введен неккорректный, будет вызвана ошибка
        _;                                              // депозит не будет создан
    }

    mapping (address => Deposit) public deposits; // создаем сопоставление адреса и структуры депозита

    struct Deposit { // создаем структуру депозита
        address contributor; // создаем адресную переменную для владельца депозита
        uint8 depositType; // создаем переменную для типа депозита
    }

    // функция создания депозита (создание элемента) и проверки условий: владельца депозита и корректного типа депозита
    // сначала проверяется владелец, после - введенный тип
    function createDeposit(address _contributor, uint8 _depositType) public onlyContributor checkType(_depositType) {
        deposits[_contributor] = (Deposit(_contributor, _depositType));
    }

    // функция закрытия депозита (удаление элемента)
    function closeDeposit(address _contributor) public onlyContributor { // только владелец депозита может его закрыть
        delete deposits[_contributor]; // удаление элемента сопоставления
    }
}
