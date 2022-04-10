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

// BSC
// https://testnet.bscscan.com/address/0xaCa0b90e27e8BdA7fD952519d21447Fe3CF99bD5
// использовал немного другой контракт чтобы узнать на каком этапе остановится
// после 3000 итераций во втором контакте цикл выполняться не будет 

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


/**
 *Submitted for verification at BscScan.com on 2022-04-10
*/

pragma solidity ^0.8.13;

contract Test {
    uint public sum;

    function testFor(uint _val1) public { // воть тут > 3000 итераций не будет работать
        for (uint i = 0; i < _val1; i++) {
            sum += 100;
        }
    }

    function testWhile(uint _val1) public {
        uint i;
        while (i != _val1) {
            sum += 100;
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
