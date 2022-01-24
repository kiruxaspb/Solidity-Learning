/* 
Задача №1
Придумать игровой контракт (то есть контракт со смыслом), где:
1. Написать функции геттер и сеттер для переменной типа string
2. Для двух переменных типа uint8 сделать функции для демонстрации арифметического переполнения: a) при сложении b) при вычитании
3. Установка контракта из пункта 2 в тестовый блокчейн Ropsten. Установка кошелька Metamask. Получение тестовых ETH.
*/

// https://ropsten.etherscan.io/address/0x1b821dAEA0eeA1eC61AFE9C62C9fA615E8f0A928#code

pragma solidity ^0.8.11; // версия компилятора

contract Game { // инициализация контракта
    string public nickname; // создание строковой переменной, доступной всем в сети
    function setNickname(string memory _nickname) public { // открытая функция, которая принимает строку, в временную переменную в памяти
        nickname = _nickname; // присваивание введенной строки нашей переменной
    }

    function getNickname() public view returns(string memory) { // открытая функция, служит для чтения переменной из памяти
        return nickname; // возврат переменной из памяти
    }
}

contract Overflow {
    // uint8: 0 <=> 255
    uint8 public a = 130; //  создаем открытую переменную и сразу присваиваем ей значение
    uint8 public b = 235;

    function add() public { // открытая функция для сложения
        uint8 res; // локальная переменная для вычисления суммы
        res = a + b; // a + b = 265 > 255, допустимого uint8, получаем ошибку при вызове функции
    }

    function sub() public { // открытая функция для вычитания
        uint8 res; // локальная переменная для вычисления разности
        res = a - b; // a - b = -95 < 0, допустимого для uint8, получаем ошибку при вызове функции
    }
}
