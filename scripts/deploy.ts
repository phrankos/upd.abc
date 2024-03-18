import { ethers } from "hardhat";

async function main() {
  const bord = await ethers.deployContract("Bord");
  await bord.waitForDeployment();
  console.log(
    ` deployed to ${bord.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});