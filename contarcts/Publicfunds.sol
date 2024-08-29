// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicFunds {
    address[] public funders;
    mapping(address => uint256) public addressToFunds;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        funders.push(msg.sender);
        addressToFunds[msg.sender] += msg.value;
    }

    function withdraw() public ownerAccess {
        require(address(this).balance > 0, "No funds to withdraw");
        payable(owner).transfer(address(this).balance);

        for (uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++) {
            address funder = funders[fundersIndex];
            addressToFunds[funder] = 0;
           
        }
        funders = new address[](0); 
    }

    modifier ownerAccess() {
        require(msg.sender == owner, "Only owner can withdraw");
        _;
    }

    fallback() external payable {
        fund();
    }
}
