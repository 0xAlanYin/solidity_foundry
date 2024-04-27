// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyERC721 is ERC721URIStorage {
    uint256 private _tokenId;

    constructor() ERC721("AlanYin", "YIN") {}

    // ipfs://QmfNJZ6SrjeTnbpcRbSdJXPqbNW6VXBotgpgpFHfpaJigx
    function mint(address person, string memory tokenURI) public returns (uint256) {
        _tokenId++;
        uint256 newItem = _tokenId;
        _mint(person, newItem);
        _setTokenURI(newItem, tokenURI);
        return newItem;
    }
}
