# Ethereum Gift Cards by TurbineSwap

Ethereum Gift Cards is an NFT project on the Arbitrum chain that wraps the value of Ether to an NFT Gift Card when it is minted. The permission to access those Ethers resides with the owner of the NFT. It can be transferred to your friends and family who can then burn the Gift Card NFT to get the underlying Ethers back. 

There is a provision of locking the access of Ethereum for up to 90 days right now at the smart contract level. UI doesn't support this yet. 

## Implementation

UI: [Turbine Swap Ethereum Gift Cards](https://turbineswap.com/egc/)
Smart Contract: [Arbiscan](https://arbiscan.io/address/0x7f6c04846f224d7ed841d01f29bf3a327d423b4c)

Launch smart contract on localhost:

```shell
npx hardhat node
npx hardhat run --network localhost scripts/deploy.ts
```
