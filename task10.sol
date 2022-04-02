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

contract SafetyDeps {
    address payable public owner;

    event DepositInfo(address indexed from, uint256 indexed depositTime, uint256 amount);
    event WithdrawInfo(address indexed to, uint256 indexed withdrawTime, uint256 amount);

    enum Status {Empty, Active, Blocked}

    mapping(address => Holder) public holders;
    struct Holder {
        address holder;
        uint balance;
        bool valid;
        Status status;
    }

    User[] public users;
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

    modifier blockCheck(address _target) {
        if (holders[_target].status == Status.Blocked) {
            revert("Deposit is blocked");
        }
        _;
    }

    function deposit() public payable {
        holders[msg.sender].holder = msg.sender;
        holders[msg.sender].balance += msg.value;
        holders[msg.sender].valid = true;
        holders[msg.sender].status = Status.Active;
        emit DepositInfo(msg.sender, block.timestamp, msg.value);
    }

    function withdrawALL() public onlyOnwer {
        payable(msg.sender).transfer(address(this).balance);
    }

    // функция вывода
    function withdrawHolder(address payable recipient, uint value) public
        onlyHolder(recipient)
        blockCheck(recipient)
        checkBalance(recipient, value)
    {   
        recipient.send(value);

        holders[recipient].balance -= value;
        if (holders[recipient].balance == 0) {
            holders[recipient].status = Status.Empty;
        }
        emit WithdrawInfo(recipient, block.timestamp, value);
    }
    
    function getBalance() public view onlyOnwer returns (uint) {
        return address(this).balance;
    }

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

    function Registration(string memory _name, uint8 age) public onlyHolder(msg.sender) {
        users.push(User(_name, age, msg.sender, 0, 0, Status.Active));
    }

    function givingBonuses(uint num) public onlyOnwer {
        for (uint i = 0; i < num && i < users.length; i++) {
            if (users[i].status != Status.Blocked) {
                users[i].bonuses += 100;
                users[i].givingTime = block.timestamp;   
            }
        }
    }

    function burnBonuses() public onlyOnwer {
        uint i;
        while (i != users.length) {
            if (block.timestamp > users[i].givingTime + 1 weeks && users[i].bonuses != 0) {
                users[i].bonuses -= 100;
            }
            i++;
        }
    }
    
    function append(string memory addition) public onlyOnwer {
        for (uint i = 0; i < users.length; i++) {
            users[i].name = string(abi.encodePacked(users[i].name, addition));
        }
    }

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