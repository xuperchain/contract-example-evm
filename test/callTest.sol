pragma solidity >=0.0.0;

contract Callee {
    address owner;
    mapping (string => uint256) values;

    constructor() public{
        owner = msg.sender;
    }
    event increaseEvent(string key,uint value);
    function increase(string memory key) public payable{
        values[key] = values[key] + 1;
        emit increaseEvent(key,values[key]);
    }

    function get(string memory key) view public returns (uint) {
        return values[key];
    }

    function getOwner() view public returns (address) {
        return owner;
    }
}

// 该solidity定义了两个合约，ContractA，ContractB,用户调用ContractB时，contractB内部会调用ContractA
contract Caller{
    Callee  public a;
    constructor(address addr) public {
        a=Callee(addr);
    }
    function cross(string memory key) public{
        a.increase(key);
    }
}