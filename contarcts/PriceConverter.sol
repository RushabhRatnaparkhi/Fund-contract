//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";



library PriceConverter{
     function getPrice() internal view returns(uint) {

        //address : 0x694AA1769357215DE4FAC081bf1f309aDC325306
         AggregatorV3Interface pricefeed=AggregatorV3Interface( 0x694AA1769357215DE4FAC081bf1f309aDC325306);
         (,int price,,,)=pricefeed.latestRoundData();
         return uint(price*1e10);
    }

  

    function getConversionRate(uint ethAmount) internal view returns(uint){

         uint ethPrice=getPrice();
         uint ethAmountInUsd=(ethPrice*ethAmount)/1e18;
         return ethAmountInUsd;
    }
}