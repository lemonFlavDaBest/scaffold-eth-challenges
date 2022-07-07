pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;
  
  

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfEth, uint256 amountofTokens);

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 tokenAmount=tokensPerEth*msg.value;
    yourToken.transfer(msg.sender, tokenAmount);
    emit BuyTokens(msg.sender, msg.value, tokenAmount);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    address owner = msg.sender;
    (bool succ, )= owner.call{value:address(this).balance}("");
    require(succ, "withdraw failed");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
      address _owner = payable(msg.sender);
      uint256 ethAmount=_amount/tokensPerEth;
      (bool tranSucc)= yourToken.transferFrom(_owner, address(this), _amount);
      require(tranSucc, "transfer failed");
      (bool success,) = _owner.call{value:ethAmount}("");
      require(success, "sale failed");
      emit SellTokens(_owner, ethAmount, _amount);
  }

}
