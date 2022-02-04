/*
Задача №6:
Работа со структурами. Написать контракт для изменения значений полей структуры.
Пусть это будет массив структур. Сделать функционал для добавления новых элементов массива
и вывода содержимого n-го элемента (сразу всех полей структуры).
Добавить в контракт из задачи 5 функционал такой, чтобы одно из полей было типа enum.
*/

// https://ropsten.etherscan.io/address/0x2943311437e2bb8B50c6f85f2235fFfD2D48cD8A#code

pragma solidity ^0.8.11;

contract SafetyDeposit {
    address payable public owner;

    event DepositInfo(address indexed from, uint256 indexed depositTime, uint256 amount); // информация о пополнениях
    event WithdrawInfo(address indexed to, uint256 indexed withdrawTime, uint256 amount); // информация о выводе
    event BlockInfo(address blockTarget, uint blockingAmount, uint indexed blockTime, string blockReason); // информация о блокировке счет

    enum Status {Empty, Active, Blocked}
    /*
    Empty - депозит пуст
    Active - использование депозита разрешено
    Blocked - использование депозита запрещено
    */

    struct Holder {
        address holder;
        uint balance;
        bool valid;
        Status status; // статус депозита
    }

    mapping(address => Holder) public holders; // массив стуктур
    /*
    отказался от использования "Holder[] public holdersList" в пользу маппинга
    тк столкнулся с функциональными проблемами, использовалась лишняя функция для поиска индекса в массиве по адресу
    не мог добавить значение нового пополнения в уже существующий элемент массива при пополнении
    */

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

    // в случае блокировки не позволит вывести с депозита
    modifier blockCheck(address _target) {
        if (holders[_target].status == Status.Blocked) {
            revert("Deposit is blocked");
        }
        _;
    }

    // функция пополнения
    function deposit() public payable {
        // вносим информацию  внесении средств в структуру массива
        holders[msg.sender].holder = msg.sender;
        holders[msg.sender].balance += msg.value;
        holders[msg.sender].valid = true;
        holders[msg.sender].status = Status.Active;
        emit DepositInfo(msg.sender, block.timestamp, msg.value); // сохраняем данные о внесении средств
    }

    // функция вывода для владельца
    function withdrawOptional(uint8 option, uint amount) public onlyOnwer checkOption(option) {
        if (option == 0) { // если введем опцию 0 - выведем указанную сумму
            if (address(this).balance < amount) {
                revert("Overflow value of withdrawals"); // отметит функцию, если введем значение большее бананса контракта
            }
            owner.transfer(amount);
        }
        if (option == 1) { // если введем 1 выведем все
           owner.transfer(address(this).balance); // выведем весь ETH с контракта
        }
    }

    function withdrawALL() public onlyOnwer {
        payable(msg.sender).transfer(address(this).balance); // выведем весь ETH с контракта
    }

    // функция вывода
    function withdrawHolder(address payable recipient, uint value) public
        onlyHolder(recipient)
        checkBalance(recipient, value)
        blockCheck(recipient)
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
}
