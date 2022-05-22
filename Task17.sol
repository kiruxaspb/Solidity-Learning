/*
Задача №17
Изучить и применить msg.sender и tx.origin.
Дать подробный комментарий (свой текст, не копипаст), что это и для чего используется.
*/

/*
msg.sender - идентификатор (address) текущего (внешнего) вызова функций или обращения к смарт-контракту.
может быть адресом внешней учетной записи, так и адресом контракта
часто применяется для работы с адресами для ведения балансов, ограничения прав, идентификации пользователя
также применятся для упрощения работы (msg.sender сразу несет в себе адрес вызывающего), в некоторых
алгоритмах применения можно избежать лишних переменных, например mapping(address => bool), где address мы можем использовать msg.sender в коде функции.

tx.origin - идентификатор отправителя(address) транзакции, возращает первое значение
при нескольких вызовах функции (стек всех адресов) ссылкается на первый адрес, который иницировал транзакцию
A -> B -> C -> D, tx.origin всегда A
может быть только адресом внешней учетной записи
! не может применяться для авторизации в контракте, поскольку симантически уязвим.
лучше избегать применение tx.origin ввиду уязвимости
можно использовать если нужен адрес из стека, а связи с безопасностью нет.
*/

// https://ropsten.etherscan.io/address/0x2d282E946BD506e243Ec71477d18ffAB656B78a0#code

pragma solidity 0.8.14;

contract CustomerCounter {
    address private owner;

    mapping (address => bool) Access;
    mapping (address => uint) customCounter;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You are not a Onwer!");
        _;
    }

    modifier havePermit {
        require(Access[msg.sender] == true, "You don't have access");
        _;
    }

    function registration() public {
        Access[msg.sender] = true;
    }

    function add(uint value) public havePermit {
        customCounter[msg.sender] += value;
    }

    function sub(uint value) public havePermit {
        customCounter[msg.sender] -= value;
    }

    function cancelPermit(address target) public onlyOwner {
        Access[target] = false;
    }
}