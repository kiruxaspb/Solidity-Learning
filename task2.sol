/*
Задача №2:
Комментарием в коде контракта дать понятие массива, перечислить виды массивов в Solidity.
Написать контракт для добавления и удаления элементов. Плюс возможность удаления N-го элемента.
Рассмотреть все варианты создания массивов (одномерные, двумерные и т.д.) и их функциональное применение.
*/

// https://ropsten.etherscan.io/address/0x04ADAcbCb51D063786e1544761963F35fC41Ec01#code

pragma solidity ^0.8.11;

contract Array {
// Массив - это последовательная совокупность значений, которая позволяет хранить данные упорядочено.
// Каждое значение в массиве имеет свой порядковый номер, по которому можно к нему обратиться (записать, изменить, удалить, получить значение)
// Индекс элемента считается с 0
// В Solidity существует: динамические массивы и массивы с фиксированной длинной, одномерные и двумерные массивы
// В элементе массиве могут содержаться такие данные как: строки, значения, структуры, массивы

    uint[] public dynamicArray; // создаем открытый динамический массив
    uint[] public dynamicArray2 = [3,2,1,2,3,4]; // можем инициализировать динамический массив сразу, тогда не потребуется его вводить
    uint[5] public fixArray; // создаем открытый статический массив
    uint[5] public fixArray2 = [5,5,5,5,5]; // можем инициализировать динамический массив сразу, тогда не потребуется его вводить
    uint[][] public tddArray; // создаем открытый двумерный динамический массив
    uint[5][5] public tdfArray; // создаем открытый двумерный статический массив
    string[2][] public mixed; // набор динамических массивов, состоящих из N элементом, в данном случае 2
    
    // setters
    function setDynamicArray(uint[] memory _dynamicArray) public { // считываем введенный массив и записываем его во временную переменную
        dynamicArray = _dynamicArray; // присваиваем динамическому массиву введенный массив
    }

    function setStaticArray(uint[5] memory _fixArray) public { // считываем введенный массив и записываем его во временную переменную
        fixArray = _fixArray; // присваиваем статичекому массиву введенный массив
    }

    function setTwoDecArray(uint[][] memory _tddArray) public { // записываем двумерный массив [[n,n,n], [m,m,m], [x,x,x]]
        tddArray = _tddArray; // присваиваем динамическому двумерному массиву введенный массив
    }

    function setTwoDecFixArray(uint[5][5] memory _tdfArray) public { // записываем двумерный массив [[n,n,n,n,n], [m,m,m,m,m], [x,x,x,x,x]]
        tdfArray = _tdfArray; // присваиваем динамическому двумерному массиву введенный массив
    }

    function changeInArray(uint _index, uint value) public { // считываем индекс и значение на которое нужно поменять
        require(_index < dynamicArray.length, "index out of length array"); // если введен индекс которого нет
        dynamicArray[_index] = value; // присваиваем новое значение указаному по индексу элементу
    }
    
    // в статическом массиве мы можем только обнулить элемент -> привести к значению/ям по умолчанию
    function removeFromArray(uint _index) public { // считываем индекс
        require(_index < fixArray.length, "index out of length array");
        delete fixArray[_index]; // устанавливает значение по умолчанию
    }

    // удалить элемент из статического массива мы не можем
    function removeByShift(uint _index) public { // считываем индекс
        require(_index < dynamicArray.length, "index out of length array");
        for (uint i = _index; i < dynamicArray.length - 1; i++) { // проходим по массиву начиная с введенного индекса
            dynamicArray[i] = dynamicArray[i + 1]; // меняем текущий элемент на идущуй далее
        }
        dynamicArray.pop(); // удаляем из массива последний элемент (уже из памяти)
    }
    
    // добавить элемент в в статический массив мы не можем
    function addInArray(uint _value) public { // получаем значение которое хотим записать в массив
        dynamicArray.push(_value); // увеличиваем массив и записываем введенное значение в созданный элемент
    }

    // удаление элемента из двумерного динамического массива -> обнуляем
    function removeTwoDecArray(uint _i, uint _j) public {
        delete tddArray[_i][_j];
    }
    
    function invalidPush() public { // заполнение смешанного массива строками
        mixed.push(["Ivan", "Judy"]);
    }

    // удаление массива
    function deleteAll() public {
        delete dynamicArray; // удаляем любой массив
    }

    // getters
    function getDynamicArray() public view returns (uint[] memory) { // возращаем массив из памяти
        return dynamicArray;
    }

    function getStaticArray() public view returns (uint[5] memory) { // возращаем массив из памяти
        return fixArray;
    }

    function getTwoDecArray() public view returns (uint[][] memory) { // возращаем массив из памяти
        return tddArray;
    }

    function getTwoDecFixArray() public view returns (uint[5][5] memory) { // возращаем массив из памяти
        return tdfArray;
    }

    // с помощью одномерного можно посчитать сумму элементов значений
    function sumResult() public view returns (uint _sum) { // задаем функцию которая предоставит доступ к массиву и вернет uint значение
        for (uint i = 0; i < dynamicArray.length; i++) { // проходим по всему массиву
            _sum += dynamicArray[i]; // _sum по умолчанию = 0 и прибавляем каждое значение элемента
        }
        return _sum; // возращаем значение суммы
    }

    // найти наибольшее значение в массиве так же и минимальное, только знак поменяется
    function high() public view returns (uint _high) {
        // _high = 0;
        for (uint i = 0; i < dynamicArray.length; i++) {
            if (dynamicArray[i] > _high) {
                _high = dynamicArray[i]; // если текущий элемент больше "_high" то он становится "_high"
            }
        }
        return _high; // возращаем полученное число
    }
}
