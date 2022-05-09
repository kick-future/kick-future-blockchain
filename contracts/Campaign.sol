// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address to;
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

    function getCountRequests() public view returns(uint) {
        return requests.length;
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

    function createRequest(string memory _description, uint _value, address _to) public {
        require(msg.sender == creator);

        Request storage request = requests.push();

        request.description = _description;
        request.value = _value;
        request.to = _to;
        request.complete = false;
        request.numberOfApproved = 0;
        request.numberAllApprovers = 0;
    }

    function approveRequest(uint index) public {
        address sender = msg.sender;
        require(donators[sender]);

        Request storage request = requests[index];
        require(!request.approvals[sender]);

        request.approvals[sender] = true;
        request.numberOfApproved++;
    }
}