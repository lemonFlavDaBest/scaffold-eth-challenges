// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";


contract Staker {

  uint256 public constant threshold = 1 ether;
  ExampleExternalContract public exampleExternalContract;
  mapping ( address => uint256 ) public balances;
  //uint private _totalSupply;
  event Stake(address indexed sender, uint256 amount);
  uint256 public deadline = block.timestamp + 100 hours;
  bool public openForWithdraw;
  

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  modifier notCompleted(){
    require(exampleExternalContract.completed() == false, "contract is already finished ");
    _;
  }
  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable {
    //_totalSupply += msg.value;
    balances[msg.sender] += msg.value;
    console.log("balance:", balances[msg.sender]);
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute() public notCompleted{
    require(timeLeft()==0);
    if (address(this).balance>=threshold) {
    exampleExternalContract.complete{value: address(this).balance}();
    } else {
      openForWithdraw = true;
    }
  } 

  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  


  // Add a `withdraw()` function to let users withdraw their balance
  function withdraw() external notCompleted{
    require(openForWithdraw, "not open for withdraw brawal");
    uint256 amount = balances[msg.sender];
    require(amount>0, "ur poor");
    address payable addr = payable(msg.sender);
    (bool success, ) = addr.call{value: amount}("");
    require(success,'not sent');
    balances[msg.sender] = 0;
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256){
    if(block.timestamp >= deadline){
      return 0;
    } else {
      return deadline - block.timestamp;
    }
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {
    stake();
  }

}
