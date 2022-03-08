/*
Задача №8:
Библиотеки. Подключить к своему контракту с арифметическими операциями (сложение и вычитание, также пусть тип будет uint256)
библиотеку безопасной математики: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol.
Разработать логику, которая используют арифметические операции с использованием этой библиотеки.
*/

// Насколько я разобрался в самом новом компиляторе уже заложены проверки на переполнение, вернется просто revert
// Немного упростил контракт и использовал функции из библиотки для учета баланса
// Использовал импорт из области проекта

// https://ropsten.etherscan.io/address/0xE1C6BF870636e5Ac4955519aE2B642a4BE08CB45#code

pragma solidity ^0.8.12;
import "./safemath.sol";

contract Deps {
    using SafeMath for uint256;

    address payable private owner;

    enum Status {Empty, Active, Blocked}

    mapping(address => Holder) private holders; // массив стуктур
    struct Holder {
        uint balance;
        Status status; // статус депозита
    }

    receive() external payable {}
    fallback() external {}

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOnwer {
        require(msg.sender == owner, "You are not a contract owner");
        _;
    }

    modifier onlyHolder(address _holder) {
        require(_holder == msg.sender, "You are not deposit owner");
        _;
    }

    function deposit() public payable {
        bool status;
        // используем функцию из библиотеки для учета пополнения баланса
        (status, holders[msg.sender].balance) = (holders[msg.sender].balance).tryAdd(msg.value);
        if (status = true) {
            holders[msg.sender].status = Status.Active;
        }
    }

    function withdrawHolder(address payable recipient, uint value) public
        onlyHolder(recipient)
    {   
        bool status;
        recipient.send(value);
        // используем функцию из библиотеки для учета вывода средств со счета
        (status, holders[recipient].balance) = (holders[recipient].balance).trySub(value);
        require(status == true, "Invalid value");
        if (holders[recipient].balance == 0) {
            holders[recipient].status = Status.Empty; // если баланс кошелька 0, обозначаем его как пустой
        }
    }
    function getBalance() public view onlyHolder(msg.sender) returns (uint balance, Status _status)
    {
        balance = holders[msg.sender].balance;
        _status = holders[msg.sender].status;
    }
}