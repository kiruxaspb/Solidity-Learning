/*
Задача №10
Новый этап - освоение контрактов для Tron и BNC

Необходимо: установить контракт с циклом for/while в тестовую сеть TRON
- установить кошелек TronLink,
- получить некоторое количество TRX.
А также отписаться сюда и сделать пометку комментарием в коде контракта
на каком шаге итерации перестает работать цикл.

Попробовать тоже самое сделать для системы Binance Smart Chain
*/

pragma solidity ^0.8.6;

contract Test {
    uint public sum;

    function testFor(uint _val1, uint _val2) public {
        for (uint i = 0; i < _val1; i++) {
            sum += _val2;
        }
    }

    function testWhile(uint _val1, uint _val2) public {
        uint i;
        while (i != _val1) {
            sum += _val2;
            i++;
        }
    }

    function showValue() public view returns (uint) {
        return sum;
    }

    function clearValue() public {
        sum = 0;
    }
}