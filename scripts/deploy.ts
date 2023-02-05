import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const lockedAmount = ethers.utils.parseEther("1");

  const name = "Ethereum Gift Cards";
  const symbol = "EGC";
  const fee = 1000000000000000;
  const feeTo = "0x707af3081b4a2841a8569a25cc1724e7e2e4a248"; 
  const maxItems = 0;
  const bURI = "https://raw.githubusercontent.com/IamRohitKGupta/EGC/main/egc-assets/info/";
  const maxLock = 7776000;
  const EGC = await ethers.getContractFactory("WrapERC721Token");
  const lock = await EGC.deploy(name, symbol, fee, feeTo, maxItems, bURI, maxLock);

  await lock.deployed();

  console.log(`Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
