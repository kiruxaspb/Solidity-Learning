/*
Задача №5:
Добавить в контракт из задачи №4 логирование событий с помощью event.
Написать контракт для получения, хранения и выдачи ETH.
Выдачу ETH реализовать 2-мя функциями: с помощью transfer и с помощью send.
Пусть с помощью transfer получает только владелец контракта, а остальные с помощью send.
*/

// https://ropsten.etherscan.io/address/0x68933058a00F4B1Ba7a2b39aAA053C75511F5b4A#code

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
        require(holderBalance[_recipient] > _amount, "Incorrect amount");
        _;
    }

    // функция получения ETH на контракт
    function depositSend(address payable to) public payable {
        to.send(msg.value); // используем метод send для внесения ETH в контракт
        emit depositInfo(msg.sender, msg.value); // записываем в лог отправителя и сумму
        verifyHolder[msg.sender] = true;
        holderBalance[msg.sender] += msg.value;
    }

    // функция вывода ETH с контракта только для владельца
    function withdraw(uint amount) external onlyOnwer {
        require(address(this).balance >= amount, "Incorrect amount"); // проверяем баланс
        payable(msg.sender).transfer(amount); // используем метод transfer для вывод всех средств с контракт для владельца
        emit withdrawInfo(block.timestamp, amount); // записываем в лог время и сумму вывода
    }

    // функция вывода средства для держателя
    function withdrawHolder(address payable recipient, uint256 amount) public payable
        verifyDeposit(recipient)
        checkBalance(recipient, amount)
    {
        (bool success, ) = recipient.call{value: amount}(""); // вывод средств с помощью метода call
        require(success, "Failed to withdraw Ether");
        holderBalance[msg.sender] -= amount;
    }

    // проверка баланса контракта для владельца
    function getBalance() public view onlyOnwer returns (uint) {
        return address(this).balance;
    }
}
