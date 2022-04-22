/*
Задача №13
Область видимости функций и переменных.
Написать контракт и подсчитать расход газа при работе с функциями и переменными,
с разной областью видимости и одной логикой работы.
Дать комментарии, какие области видимости в Solidity есть, а также комментарии,
содержащие выводы анализа затратности газа для работы с функциями и переменными с разной областью видимости
*/

/*
В solidity существуют 4 типа указателя области видимости для функций:
1. public
2. private
3. internal
4. external

и 3 указателя для переменных:
1. public
2. private
3. internal
*/

// дешевле всего работать с private, internal функциями и любым visibility для переменных
// если рассматривать переменные, то дешевле работать с public переменными

// https://ropsten.etherscan.io/address/0x3220479CA73E259bD4C8B9B4a4979324F429afA9#code

pragma solidity ^0.8.13;

contract GasVisibilityTests {
    uint public publicValue;
    uint private privateValue;
    uint internal internalValue;

    // public variebles tests
    function publicFuncTest() public {
        publicValue = 100; // transaction cost 23444 gas
    }

    function privateFuncTest() private {
        publicValue = 100; // transaction cost 22138 gas
    }

    function internalFuncTest() internal {
        publicValue = 100; // transaction cost 22138 gas
    }

    function externalFuncTest() external {
        publicValue = 100; // transaction cost 23423 gas
    }

    // private variebles tests
    function publicFuncTest1() public { 
        privateValue = 100; // transaction cost 43388 gas
    }

    function privateFuncTest1() private {
        privateValue = 100; // transaction cost 22138 gas
    }

    function internalFuncTest1() internal {
        privateValue = 100; // transaction cost 22138 gas
    }

    function externalFuncTest1() external { 
        privateValue = 100; // transaction cost	23410 gas
    }

    // internal variebles tests
    function publicFuncTest2() public {
        internalValue = 100; // transaction cost 43345 gas
    }

    function privateFuncTest2() private {
        internalValue = 100; // transaction cost 22138 gas
    }

    function internalFuncTest2() internal {
        internalValue = 100; // transaction cost 22138 gas
    }

    function externalFuncTest2() external {
        internalValue = 100; // transaction cost 23466 gas
    }


    // calls private & internal funcs
    function test22() public {
    // 21275 gas цена пустой функции
    // тут вызывал функции и вычитал из общей стоимости с вызванной функцией цену пустой функции
        internalFuncTest();
    }
}
