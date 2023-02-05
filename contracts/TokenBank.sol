// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenBank is Ownable, ReentrancyGuard {
    mapping(uint256 => uint256) private _tokenBalance;
    mapping(uint256 => uint256) private _unlockEpoch;

    function deposit(uint256 tokenId, uint256 unlockEpoch) payable external onlyOwner nonReentrant {
        _tokenBalance[tokenId] = msg.value;
        _unlockEpoch[tokenId] = unlockEpoch;
    }

    function withdraw(uint256 tokenId, address owner) external onlyOwner nonReentrant {
        require(block.timestamp >= _unlockEpoch[tokenId], "Wait for unlock.");
        payable(owner).transfer(_tokenBalance[tokenId]);
        _tokenBalance[tokenId] = 0;
    }

    function balanceOfToken(uint256 tokenId) external view returns (uint256) {
        return _tokenBalance[tokenId];
    }

    function getUnlockDate(uint256 tokenId) external view returns (uint256) {
        return _unlockEpoch[tokenId];
    }
}