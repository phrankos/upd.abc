// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract DataSaver {
    uint public data;

    function setData(uint _data) public {
        data = _data;
    }
}