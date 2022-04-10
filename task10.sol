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
// TRON
// https://nile.tronscan.org/#/contract/TMtUa3don462G85mCsR1b4T568jDNjqfbn/code
// лимит при деплое 1000TRX
// практическим способом нашел цену одной итерации ~ 2 TRX
// на 500 итерации цикла, он будет остановлен

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

contract TestCicles {

    User[] public users;
    struct User {
        string name;
        address wallet;
        uint16 balance;
    }

    function Registration(string memory _name) public  {
        users.push(User(_name, msg.sender, 0));
    }

    function add() public {
        for (uint i = 0; i < users.length; i++) { // при массиве более 500 элементов цикл не доработает до конце
                users[i].balance += 100;  
        }
    }
}
