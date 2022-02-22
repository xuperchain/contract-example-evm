pragma solidity >=0.0.0;

//eventTest is used to test various types of solidity events
contract eventTest {
    address owner;
    constructor() public{
        owner = msg.sender;
    }

    event multiArgsEvent(address addr,bytes32 name, bool boolValue, int number, string methondName);

    event Uint256OneEvent(uint256);
    event Uint256OneIndexEvent(uint256 indexed);
    event Uint256TwoIndexEvent(uint256 indexed,uint256 index);
    event Uint256TwoIndexFirstEvent(uint256 indexed,uint256);
    event Uint256TwoIndexSecEvent(uint256,uint256 index);

    event Int256OneEvent(int256);
    event Int256OneIndexEvent(int256 indexed);
    event Int256TwoIndexEvent(int256 indexed,int256 index);
    event Int256TwoIndexFirstEvent(int256 indexed,int256);
    event Int256TwoIndexSecEvent(int256,int256 index);

    event AddressOneIndexEvent(address indexed);
    event AddressTwoIndexEvent(address indexed,address indexed);
    event AddressTwoIndexFirstEvent(address indexed,address);
    event AddressTwoIndexSecEvent(address,address indexed);

    event BoolOneIndexEvent(bool indexed);
    event BoolTwoIndexEvent(bool indexed,bool indexed);
    event BoolTwoIndexFirstEvent(bool indexed,bool);
    event BoolTwoIndexSecEvent(bool,bool indexed);

    event StringOneIndexEvent(string indexed);
    event StringTwoIndexEvent(string indexed,string indexed);
    event StringTwoIndexFirstEvent(string indexed,string);
    event StringTwoIndexSecEvent(string,string indexed);

    event Byte32OneIndexEvent(bytes32 indexed);
    event Byte32TwoIndexEvent(bytes32 indexed,bytes32 indexed);
    event Byte32TwoIndexFirstEvent(bytes32 indexed,bytes32);
    event Byte32TwoIndexSecEvent(bytes32,bytes32 indexed);
    event BytesOtherTypeEvent(bytes2,bytes5,bytes20);
    event BytesOtherTypeEventIndexed(bytes2 indexed,bytes5 indexed,bytes20 indexed);

    event SameNameEvent(string,int);
    event SameNameEvent(int,string );

    // 测试byte相关事件，此例子中测试了byte2,byte23,byte20,可自定义修改byte长度，最大长度为byte32
    function testBytes() public payable {
        bytes2 b2 = 0xabcd;
        bytes5 b5 = "hello";
        bytes20  b20 = hex"1234";
        emit BytesOtherTypeEvent(b2,b5,b20);
        emit BytesOtherTypeEventIndexed(b2,b5,b20);
    }

    // 测试Uint相关事件，此例子中仅测试了uint256,可自定义修改uint长度，最大长度为uint256
    function testUint256Event(uint256 a,uint256 b)public payable{
        emit Uint256OneEvent(a);
        emit Uint256OneIndexEvent(a);
        emit Uint256TwoIndexEvent(a,b);
        emit Uint256TwoIndexFirstEvent(a,b);
        emit Uint256TwoIndexSecEvent(a,b);
    }

    // 测试int相关事件，此例子中仅测试了int256,可自定义修改int长度，最大长度为int256
    function testint256Event(int256 a,int256 b)public payable{
        emit Int256OneEvent(a);
        emit Int256OneIndexEvent(a);
        emit Int256TwoIndexEvent(a,b);
        emit Int256TwoIndexFirstEvent(a,b);
        emit Int256TwoIndexSecEvent(a,b);
    }

    // 测试Address相关事件，Address为一个长度为40的16进制数字
    function testAddresxsEvent(address a,address b) public payable{
        emit AddressOneIndexEvent(a);
        emit AddressTwoIndexEvent(a,b);
        emit AddressTwoIndexFirstEvent(a,b);
        emit AddressTwoIndexSecEvent(a,b);
    }

    // 测试Bool相关事件
    function testBoolEvent(bool a,bool b) public payable{
        emit BoolOneIndexEvent(a);
        emit BoolTwoIndexEvent(a,b);
        emit BoolTwoIndexFirstEvent(a,b);
        emit BoolTwoIndexSecEvent(a,b);
    }

    //测试String相关事件，带有indexed的参数在事件订阅中返回为该字符串的 Keccak256Hash 哈希值
    function testStringEvent(string memory a, string memory b) public payable{
        emit StringOneIndexEvent(a);
        emit StringTwoIndexEvent(a,b);
        emit StringTwoIndexFirstEvent(a,b);
        emit StringTwoIndexSecEvent(a,b);
    }

    //测试bytes32相关事件，测试是否带有indexed以及indexed的顺序对事件的影响
    function testBytes32Event(bytes32 a, bytes32 b) public payable{
        emit Byte32OneIndexEvent(a);
        emit Byte32TwoIndexEvent(a,b);
        emit Byte32TwoIndexFirstEvent(a,b);
        emit Byte32TwoIndexSecEvent(a,b);
    }

    // 测试所有类型参数的事件。该事件参数包好了以上各个类型
    function MultiArgs() public payable{
        bytes32 name = "bytes32";
        int  number = 25;
        emit multiArgsEvent(owner,name,true,number,"multiArgsEvent is tested for solidity type");
    }

    //单独测试不带Indexed的 Uint256
    function TestUint256WithoutIndexed(uint256 a) public payable{
        emit Uint256OneEvent(a);
    }

    // 单独测试带有Indexed的Uint256
    function TestUint256Indexed(uint256 a) public payable{
        emit Uint256OneIndexEvent(a);
    }

    // 测试相同名字，参数不同的事件
    function TestSameNameEvent(int n,string memory s) public payable{
        emit SameNameEvent(n,s);
        emit SameNameEvent(s,n);
    }
}