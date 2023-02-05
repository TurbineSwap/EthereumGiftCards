// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./TokenBank.sol";

contract WrapERC721Token is ERC721URIStorage, ERC721Enumerable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 private _fee;
    address private _feeTo;
    uint256 private _maxItems;
    address private _tokenBank;
    string private _bURI;
    uint256 private _maxLock;

    event MintNewItem(uint256 indexed newItemId);

    constructor(string memory name, string memory symbol, uint256 fee, address feeTo, uint256 maxItems, string memory bURI, uint256 maxLock)
        ERC721(name, symbol) {
        _fee = fee;
        _feeTo = feeTo;
        _maxItems = maxItems;
        _bURI = bURI;
        _maxLock = maxLock;
        TokenBank tokenBank = new TokenBank();
        _tokenBank = address(tokenBank);
    }

    function mintItem(address user, uint256 unlockEpoch)
        public payable nonReentrant
        returns (uint256) {
        //require(_tokenIds.current() < _maxItems, "NFTs mint limit reached!");
        require(msg.value >= _fee * 10, "Fee not met.");
        require(unlockEpoch <= block.timestamp + _maxLock, "Reduce lock time.");

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(user, newItemId);
        string memory autoTokenURI = string.concat(Strings.toString(newItemId), ".json");
        _setTokenURI(newItemId, autoTokenURI);

        emit MintNewItem(newItemId);

        payable(_feeTo).transfer(_fee);
        TokenBank(_tokenBank).deposit{value: msg.value - _fee}(newItemId, unlockEpoch);

        return newItemId;
    }

    function burnItem(uint256 tokenId) external nonReentrant {
        require(msg.sender == this.ownerOf(tokenId), "Caller must be NFT Owner!");
        //require(TokenBank(_tokenBank).balanceOfToken(tokenId) > 0, "NFT already burnt!");
        require(this.isApprovedForAll(msg.sender, address(this)), "Not Approved!");

        TokenBank(_tokenBank).withdraw(tokenId, msg.sender);
        this.safeTransferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenId);
    }

    // Overrides

    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) 
        internal virtual 
        override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // Overrides end

    function getFee() external view returns (uint256) {
        return _fee;
    }

    function getFeeTo() external view returns (address) {
        return _feeTo;
    }

    function getTokenBank() external view returns (address) {
        return _tokenBank;
    }

    function _baseURI() internal view override returns (string memory) {
        return _bURI;
    }

    function getMaxLock() external view returns (uint256) {
        return _maxLock;
    }

    function setFee(uint256 fee) external onlyOwner {
        _fee = fee;
    }

    function setFeeTo(address feeTo) external onlyOwner {
        _feeTo = feeTo;
    }

    function setBaseURI(string calldata bUri) external onlyOwner {
        _bURI = bUri;
    }

    function setMaxLock(uint256 maxLock) external onlyOwner {
        _maxLock = maxLock;
    }
}
