const hre = require("hardhat");

async function main() {
  const X = await ethers.getContractFactory("JustAnotherHelp");
  const x = await X.deploy();
  await x.deployed();
  
  console.log("X deployed to:", x.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
