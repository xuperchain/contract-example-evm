//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.0.0;

contract paramTest {

    constructor() public{

    }


    function b32(bytes32 key) public returns(bytes32){
        return key;
    }

    function b(bytes memory key) public returns(bytes memory){
        return key;
    }

    function strings(string memory key) public returns(string memory){
        return key;
    }

    function stringArr(string[] memory key) public returns(string[] memory) {
        return key;
    }

    function addr(address  key) public returns(address) {
        return key;
    }

    function addrArr(address[] memory key) public returns(address[] memory){
        return key;
    }

    function uints(uint  key) public returns(uint){
        return key;
    }

    function uintArr(uint[] memory key) public returns(uint[] memory) {
        return key;
    }

    function bools(bool  key) public returns(bool){
        return key;
    }

    function ints(int  key) public returns(int) {
        return key;
    }

    function intArr(int[] memory key) public returns(int[] memory) {
        return key;
    }

}