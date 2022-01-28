/*
Задача №4:
Работа с несколькими контрактами. Интерфейсы. Реализовать логику таким образом,
чтобы функции из одного контракта были доступны для другого контракта.
Но необходимо ограничить доступ к функциям первого контракта так,
чтобы их мог вызывать только второй контракт.
*/

// Реализация с помощью наследования:
// https://ropsten.etherscan.io/address/0x8f38A2252C9435035970B2149B98074d9f987B7A#code

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
