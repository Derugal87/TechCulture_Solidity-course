const hre = require("hardhat");

async function main() {
  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy();
  await myToken.deployed();
  console.log("MyToken contract: ", myToken.address);

  const Stake = await hre.ethers.getContractFactory("Stake");
  const stake = await Stake.deploy(myToken.address);
  await stake.deployed();
  console.log("Stake contract: ", stake.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
