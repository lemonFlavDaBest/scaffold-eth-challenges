const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const diceGame = await ethers.getContract("DiceGame", deployer);

  
  await deploy("RiggedRoll", {
   from: deployer,
   args: [diceGame.address],
   log: true,
  });
  

  const riggedRoll = await ethers.getContract("RiggedRoll", deployer);

  const ownershipTransaction = await riggedRoll.transferOwnership("0x34F5b4ED395209Ae2BA9B80c519F7270c1e0C7b4");
  

};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["RiggedRoll"];
