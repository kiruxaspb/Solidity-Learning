/*
Задача №18
Вызовы функций между контрактами.
Отличия между Call, StaticCall и DelegateCall.
Прописать комментариями отличия и особенности.
*/

/*
Низкоуровневые функции языка solidity, с помощью которых можно обращаться к функциям внешних контрактов
Call - с помощью метода <variable contract address>.call(<data>) можно обратиться к функции внешнего контракта, при том
мы можем обратиться к функции контракта A(вызываемый контракт), но логика функции исполнятся в рамках в контракта B (откуда был вызов)
но переменные будут изменяться в контракте А

StaticCall - метод применяется для обращения к view и pure функциям внешнего контракта, которые не требуют изменения состояния
использование метода предотвращает изменение переменных на уровне EVM

DelegateCall - метод предполагает обращение к функциям внешнего контракта с применением перменных и функций на стороне
контракта (caller), который вызвал метод delegatecall, будет использоваться только код из вызываемого контакта.
*/

// call

contract First {
    event GetCall(address caller, string message, uint __x);

    fallback() external payable {
        emit GetCall(msg.sender, "Fallback was called", 0);
    }

    function test(string memory _message, uint _x) public payable returns (uint) {
        emit GetCall(msg.sender, _message, _x + 1);

        return _x;
    }
}


contract Second {
    event Answer(bool success, bytes data);

    function testCall(address payable _address) public payable {
        (bool success, bytes memory data) = _address.call(
            abi.encodeWithSignature("test(string,uint256)", "call test", 1)
        );

        emit Answer(success, data);
    }

    function callnotTest(address _address) public {
        (bool success, bytes memory data) = _address.call(
            abi.encodeWithSignature("notTest()")
        );

        emit Answer(success, data);
    }
}

// delegateCall

contract One {
    uint public number;
    uint public customValue;
    address public sender;
    // в обоих контрактах нужно соблюсти одиннаковую структуру хранения
    function setVariables(uint _number) public payable {
        number = _number;
        sender = msg.sender;
        customValue = msg.value;
    }
}


contract Two {
    uint public number;
    uint public customValue;
    address public sender;
    
    function setVaiables(address _contract, uint _number) public payable {
        // переменная A контакта изменена, B не изменяется. берем только код из A
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVariables(uint256)", _number)
        );
    }
}

// staticCall
contract OneOne {
    uint public value;

    constructor() {
        value = 100;
    }

    function returnValue() public view returns (uint) {
        return value;
    }
}


contract TwoTwo {
    function test(address _contract) public view returns (bool) {
        (bool status,) = _contract.staticcall(
            abi.encodeWithSignature("returnValue()")
        );
        return status;
    }
}