/*
Задача №16
Изучение спецификации ERC-20. Написать контракт с собственным токеном.
Комментарием до кода кратко описать функции, которые реализуются в стандартном ERC-20,
основное его назначение, а также какие еще виды спецификаций токенов существуют у Ethereum.
В идеале - отразить их функции также кратко
*/

// ERC-20 token: https://ropsten.etherscan.io/tokens?q=0xc201AB229EcD9692f5e7326cF2496aF4CA0b02e6
// contract: https://ropsten.etherscan.io/address/0xc201AB229EcD9692f5e7326cF2496aF4CA0b02e6#code

// ERC-20(fungible tokens) - спецификация для создания взаимозаменяемых токенов 1 к 1, имеет функционал для передачи токенов,
// также стандарт дает возможность утвердить токены, чтобы токен мог использоваться третьей стороной
/*
    1.function totalSupply() external view returns (uint256);
        - переменная в ERC-20: _totalSupply - значение общего количества токенов

    2.function balanceOf(address account) external view returns (uint256);
        - функция позволяет получить из мапинга количество токенов, относящееся к конкретному адресу

    3.function allowance(address owner, address spender) external view returns (uint256);
        - возращает значение количества токена, которое может быть отправлено через transferFrom

    4.function transfer(address recipient, uint256 amount) external returns (bool);
        - функция отправки токена с кошелька держателя токенов получателю "recipient"

    5.function approve(address spender, uint256 amount) external returns (bool);
        - устанавливает значение количества токенов, которые могут быть направлены получателю "spender"

    6.function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
        - отправляет количество токенов, которое не превышает allowance() на баланс получателя с баланса держателя
        с согласия держателя токенов
*/

// ERC-721 (non-fungible tokens) - спецификация невзаимозаменяемого токена, используется для уникальной идентификации чего либо
// каждый токен контракта отличен друг от друг

/*
function balanceOf(address _owner) external view returns (uint256);
    - возращает количество nft на балансе конкретного кошелька

function ownerOf(uint256 _tokenId) external view returns (address);
    - функция для поиск адреса, которому принадлежит nft

function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
    - функция для переноса "права собственности" nft с одного адреас на друой с дополнительной информацией

function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    - работает также как и функция выше, только устанавливает data - ""

function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    - функция для передачи права на токена на адрес _to, в случае если адрес невалиден, токен будет потерян

function approve(address _approved, uint256 _tokenId) external payable;
    - функция для утверждения владельца токена

function setApprovalForAll(address _operator, bool _approved) external;
    - изменение возможности потверждения 3 стороны (оператор управления)

function getApproved(uint256 _tokenId) external view returns (address);
    - получить потвержденный адрес токена

function isApprovedForAll(address _owner, address _operator) external view returns (bool);
    - проверка является ли адрес потвержденным оператором
*/

/*
// ERC-777 - расширяет функционал стандарта ERC-20, с сохранением совместимости с ERC-20

function authorizeOperator(address operator) external
    - устанавливает адрес стороннего оператора как msg.sender для отправки или сжигания токенов от его лица

function revokeOperator(address operator) external
    - удаление адреса как стороннего оператора как msg.sender

function operatorSend(
    address from,
    address to,
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
) external
    - отправка токенов от лица адреса (from) на адрес (to)

function burn(uint256 amount, bytes calldata data) external
    - сжигание указанного количества токенов у msg.sender

function operatorBurn(
    address from,
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
) external
    - сжигание "amount" количества токенов от лица "from"

function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
    - уведомление о переводе токенов

function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;
    - уведомление о любом увеличении баланса

*/

// ERC-1155 - объединяет в себе стандарты ERC20 и ERC721 и дает возможность настраивать тип каждого токена

/*



*/

pragma solidity ^0.8.13;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract TaskTestToken is IERC20 {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private _totalSupply;

    constructor(uint256 _emission) {
        name = "Task Test Token";
        symbol = "TTT";
        decimals = 9;

        // 100 KTN
        _balances[msg.sender] = _emission;
        _totalSupply = _emission;
    }
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= _balances[msg.sender]);
        require(to != address(0));

        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }
}


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }    

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}