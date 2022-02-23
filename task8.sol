/*
Задача №8:
Циклы while и for. В наш контракт добавить такой функционал, чтобы можно было убедиться,
что число итераций цикла в рамках одной транзакции ограничено.
Опытным путем вычислить это число для своего цикла.
*/

// https://ropsten.etherscan.io/address/0x4d57c0B1014AF3Dd56B6D3662a541b3e30CE6878#code
// работа с итерациями - строки 167 <-> 196
pragma solidity ^0.8.12;

contract Safety {
    address payable public owner;

    event DepositInfo(address indexed from, uint256 indexed depositTime, uint256 amount); // информация о пополнениях
    event WithdrawInfo(address indexed to, uint256 indexed withdrawTime, uint256 amount); // информация о выводе
    event BlockInfo(address indexed blockTarget, uint indexed blockingAmount, uint indexed blockTime, string blockReason); // информация о блокировке счет

    enum Status {Empty, Active, Blocked}

    mapping(address => Holder) public holders; // массив стуктур
    struct Holder {
        address holder;
        uint balance;
        bool valid;
        Status status; // статус депозита
    }

    User[] public users; // для 7 задачи
    struct User {
        string name;
        uint8 age;
        address wallet;
        uint16 bonuses;
        uint givingTime;
        Status status;
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
        require(holders[msg.sender].valid == true, "You are not deposit owner");
        _;
    }

    modifier checkBalance(address _holder, uint _amount) {
        require(holders[_holder].balance >= _amount, "Overflow value of withdrawals");
        _;
    }

    // проверка
    modifier checkOption(uint8 test) {
        require(test == 0 || test == 1, "Use 0 or 1");
        _;
    }

    modifier blockCheck(address _target) {
        if (holders[_target].status == Status.Blocked) {
            revert("Deposit is blocked");
        }
        _;
    }

    // функция пополнения
    function deposit() public payable {
        holders[msg.sender].holder = msg.sender;
        holders[msg.sender].balance += msg.value;
        holders[msg.sender].valid = true;
        holders[msg.sender].status = Status.Active;
        emit DepositInfo(msg.sender, block.timestamp, msg.value); // сохраняем данные о внесении средств
    }

    // функция вывода для владельца
    function withdrawOptional(uint8 option, uint amount) public onlyOnwer checkOption(option) {
        if (option == 0) {
            if (address(this).balance < amount) {
                revert("Overflow value of withdrawals");
            }
            owner.transfer(amount);
        }
        if (option == 1) {
           owner.transfer(address(this).balance);
        }
    }

    function withdrawALL() public onlyOnwer {
        payable(msg.sender).transfer(address(this).balance); // выведем весь ETH с контракта
    }

    // функция вывода
    function withdrawHolder(address payable recipient, uint value) public
        onlyHolder(recipient)
        blockCheck(recipient)
        checkBalance(recipient, value)
    {   
        recipient.send(value);

        holders[recipient].balance -= value; // изменяем значение баланса
        if (holders[recipient].balance == 0) {
            holders[recipient].status = Status.Empty; // если баланс кошелька 0, обозначаем его как пустой
        }
        emit WithdrawInfo(recipient, block.timestamp, value);
    }
    
    // получаем значение баланса контракта
    function getBalance() public view onlyOnwer returns (uint) {
        return address(this).balance;
    }

    // если депозит существует, то вызывающий получит информацию только о своем в владе
    function getDepositInfo() public view onlyHolder(msg.sender) returns (
        uint balance,
        bool validation,
        Status _status
    )
    {
        balance = holders[msg.sender].balance;
        validation = holders[msg.sender].valid;
        _status = holders[msg.sender].status;
    }

    // функция получения информации о депозите для владельца контракта
    function getDepositInfo(address target) public view onlyOnwer returns (
        address holder,
        uint balance,
        bool validation,
        Status _status
    )
    {
        holder = holders[target].holder;
        balance = holders[target].balance;
        validation = holders[target].valid;
        _status = holders[target].status;
    }

    // изменение поля структуры в массиве
    // блокировка депозита
    function blockDeposit(address target, string memory reason) public onlyOnwer {
        holders[target].status = Status.Blocked;
        emit BlockInfo(target, holders[target].balance, block.timestamp, reason);
    }

    // разблокировка депозита
    function unblockDeposit(address target) public onlyOnwer {
        holders[target].status = Status.Active;
    }

    // заполнение массива для 7 задачи
    // регистрацию может пройти пополнивший счет пользователь
    function Registration(string memory _name, uint8 age) public onlyHolder(msg.sender) {
        users.push(User(_name, age, msg.sender, 0, 0, Status.Active));
    }

    // 7 задача
    // изменение числового типа c помощью for

    // В ЭТОМ ФАЙЛЕ:
    // *К 8 задаче: в рамках транзакции для добавление в блок существует ограничение в (80000000 gas) для этого необходимо
    // в случае работы с массивами:
    // 1. большие функции в рамках возможности разбивать на дополнительные для оптимизации расхода gas
    // 2. пропускать работу с некоторыми элементами массива с которыми можно не работать (какие нибудь условия, привел пример)
    function givingBonuses() public onlyOnwer {
        for (uint i = 0; i < users.length; i++) { // начисляем бонусы всем пользователям
            // если пользователь в блоке бонусы не даем
            // если не будет ограничения, тратим газ на размер всего массива, в этом же случае N - (blocked_users)
            if (users[i].status != Status.Blocked) {
                users[i].bonuses += 100;
                users[i].givingTime = block.timestamp;   
            }
        }
    }

    // контроль неисользуемых бонусов
    // каждую неделю уменьшаются бонусы
    function burnBonuses() public onlyOnwer {
        uint i;
        while (i != users.length) {
            // *если по элементу массива не будет совпадений
            // экономим газ, пропуская некоторых пользователей
            // N - (lifetimebonuses + bonuses = 0)
            if (block.timestamp > users[i].givingTime + 1 weeks && users[i].bonuses != 0) {
                users[i].bonuses -= 100;
            }
            i++;
        }
    }
    
    // с помощью функции можем добавлять произвольное количество символов в каждое поле строки в массиве
    function append(string memory addition) public onlyOnwer {
        for (uint i = 0; i < users.length; i++) {
            users[i].name = string(abi.encodePacked(users[i].name, addition));
        }
    }

    // информация о пользователе
    function getInfo() public view returns (
        address _wallet,
        string memory userName,
        uint8 userAge,
        uint16 userBonuses,
        uint userBalance
    )
    {
        for (uint i = 0; i < users.length; i++) {
                userName = users[i].name;
                userAge = users[i].age;
                userBonuses = users[i].bonuses;
                userBalance = holders[msg.sender].balance;
        }
        return (msg.sender, userName, userAge, userBonuses, userBalance);
    }
}
