// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Bord is Ownable(msg.sender) {
    uint public price = 0.00001 ether;
    uint public increment = 0.00001 ether;
    uint public numberSubmissions = 0;
    string public message;

    function submitMsg(string memory _message) external payable {
        require(msg.value >= price, "Insufficient funds");
        price += increment;
        numberSubmissions += 1;
        message = _message;
    }

    function setPrice(uint _price) external onlyOwner {
        price = _price;
    }

    function resetPrice() external onlyOwner {
        price = 0.00001 ether;
    }

    function resetNumberSubmissions() external onlyOwner {
        numberSubmissions = 0;
    }

    function withdrawBalance() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

// 0.00001 ETH -> 0.036 USD