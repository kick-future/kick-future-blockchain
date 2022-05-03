// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint numberOfApproved;
        uint numberAllApprovers;
        mapping(address => bool) approvals;
    }

    uint public minimumDonation;
    address public creator;
    Request[] public requests;
    mapping(address => bool) public donators;
    uint public numberOfDonators;
    uint public balance;

    constructor(uint _minimumDonation, address _creator) {
        minimumDonation = _minimumDonation;
        creator = _creator;
    }

    function donate() public payable {
        uint value = msg.value;
        address sender = msg.sender;

        require(value > minimumDonation);
        balance += value;

        if (!donators[sender]) {
            donators[sender] = true;
            numberOfDonators++;
        }
    }
}