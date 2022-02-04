/*
Задача №5:
Добавить в контракт из задачи №4 логирование событий с помощью event.
Написать контракт для получения, хранения и выдачи ETH.
Выдачу ETH реализовать 2-мя функциями: с помощью transfer и с помощью send.
Пусть с помощью transfer получает только владелец контракта, а остальные с помощью send.
*/

// https://ropsten.etherscan.io/address/0xB09Dc7D007757608cd98DD470F8a9eB25579093d#code

pragma solidity ^0.8.11;

contract Deposit {
    address payable private owner;
    event depositInfo(address sender, uint amount);
    event withdrawInfo(uint time, uint amount);

    mapping(address => uint) public holderBalance; // баланс держателя
    mapping(address => bool) public verifyHolder; // подтвеждение внесения средств

    receive() external payable {} // возврат в случае неккоректного ввода
    fallback() external {}

    constructor() {
        owner = payable(msg.sender);  // задаем адрес владельца контракта
    }

    modifier onlyOnwer { // владелец контракта
        require(msg.sender == owner, "You are not a contract owner");
        _;
    }

    // владелец депозита
    modifier verifyDeposit(address _recipient) {
        require(verifyHolder[_recipient] == true, "You are not a deposit owner");
        _;
    }

    // чтобы не превысить сумму депозита при выводе
    modifier checkBalance(address _recipient, uint _amount) {
        if (holderBalance[_recipient] < _amount)
            revert("The output value exceeds the balance");
        _;
    }

    // функция получения ETH на контракт
    function deposit() public payable {
        verifyHolder[msg.sender] = true;
        holderBalance[msg.sender] += msg.value;
        emit depositInfo(msg.sender, msg.value); // записываем в лог отправителя и сумму
    }

    // функция вывода ETH с контракта только для владельца
    function withdraw(uint amount) external onlyOnwer {
        require(address(this).balance >= amount, "Incorrect amount"); // проверяем баланс
        owner.transfer(amount); // используем метод transfer для вывод всех средств с контракт для владельца
        emit withdrawInfo(block.timestamp, amount); // записываем в лог время и сумму вывода
    }

    // функция вывода средства для держателя
    function withdrawHolder(address payable recipient, uint256 amount) public
        verifyDeposit(recipient)
        checkBalance(recipient, amount)
    {
            recipient.send(amount); // вывод для пользователя с помощью send
            holderBalance[msg.sender] -= amount;
    }

    // проверка баланса контракта для владельца
    function getBalance() public view onlyOnwer returns (uint) {
        return address(this).balance;
    }
}
