//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PriceConverter.sol";

error NotOwner();

contract FundMe{
    using PriceConverter for uint;
     
    uint public constant MINIMUM_USD=5*1e18;

  address[] public funders;
  mapping(address => uint)public addressToAmountFunded;
  address public immutable i_owner;

  constructor(){
   i_owner=msg.sender;
  }

    function fund()public payable{
        
        //require(msg.value.getConversionRate()>=MINIMUM_USD,"Didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] +=msg.value;
    }

    function withdraw()public onlyOwner{
      
      for(uint funderIndex = 0; funderIndex < funders.length; funderIndex++)
      {
        address funder=funders[funderIndex];
        addressToAmountFunded[funder]=0;
          
      }
      funders = new address[](0);
      (bool callSuccess,)=payable(msg.sender).call{value:address(this).balance}("");
      require(callSuccess,"Call failed");
    }

    modifier onlyOwner{
      require(msg.sender==i_owner,"Sender is not the owner");
    //if(msg.sender==i_owner){revert NotOwner();}
      _;
    }
    receive() external payable{
      fund();
    }

    fallback()external payable{
      fund();

    }

  

  
}