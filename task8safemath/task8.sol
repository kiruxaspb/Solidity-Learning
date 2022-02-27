/*
Задача №8:
Библиотеки. Подключить к своему контракту с арифметическими операциями (сложение и вычитание, также пусть тип будет uint256)
библиотеку безопасной математики: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol.
Разработать логику, которая используют арифметические операции с использованием этой библиотеки.
*/

// Насколько я разобрался в самом новом компиляторе уже заложены проверки на переполнение, вернется просто revert

pragma solidity ^0.8.12;
import "./safemath.sol";

contract SafeMathTest {
    function test() public {
        
    }
}