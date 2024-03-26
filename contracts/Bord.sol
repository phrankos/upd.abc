// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Bord is Ownable(msg.sender) {
    uint public tokenPrice = 0.00001 ether;
    uint public submitPrice = 1 * 10 ** 18;         // 1 Bord Token
    uint public increment = 1 * 10 ** 18;           // 1 Bord Token
    uint public numberSubmissions = 0;
    string public message;
    address private lastPaid;

    ERC20 public bordToken = ERC20(0x37462BC24cA3708631697D7a38Aa2BBF0b7b0BA1);

    // 0.00001 ETH <-> 0.036 USD
    // 0.00001 ETH <-> 1 BRD
    // 1 ETH <-> 100000 BRD 
    // 1 BRD = 1000000000000000000

    function buyTokens(uint amount) public payable {
        require(msg.value >= tokenPrice * amount, "Insufficient funds");

        // check if the Vendor Contract has enough amount of tokens for the transaction
        uint256 vendorBalance = bordToken.balanceOf(address(this));
        require(vendorBalance >= amount, "Bord has not enough Bord Tokens");

        // Transfer token to the msg.sender
        bordToken.transfer(msg.sender, amount * 10 ** 18);
    }

    function submitMsg(string memory _message) external {
        // require(bordToken.transferFrom(msg.sender, address(this), submitPrice)); // cant figure out how to make transfer from work properly :<
        submitPrice += increment;                  // Increment submitPrice by 'increment' amount of Bored Tokens
        numberSubmissions += 1;                    // Increment the number of submissions
        message = _message;                        // Change the current message
    }

    function setTokenPrice(uint _tokenPrice) external onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function setSubmitPrice(uint _submitPrice) external onlyOwner {
        submitPrice = _submitPrice;
    }

    function resetSubmitPrice() external onlyOwner {
        submitPrice = 1 * 10 ** 18;
    }

    function resetNumberSubmissions() external onlyOwner {
        numberSubmissions = 0;
    }

    function withdrawBalance() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}