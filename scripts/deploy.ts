import { ethers } from "hardhat";

async function main() {
  // const bordToken = await ethers.deployContract("BordToken");
  // await bordToken.waitForDeployment();
  // console.log(
  //   ` deployed BordToken to ${bordToken.target}`
  // );

  const Bord = await ethers.getContractFactory("Bord");
  const bord = await Bord.deploy();
  // const bord = await ethers.deployContract("Bord", [tokenAddress]);
  await bord.waitForDeployment();
  console.log(
    ` deployed Bord to ${bord.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// npx hardhat run scripts/deploy.ts --network arbitrumSepolia