// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    uint256 private _tokenId;

    constructor() ERC721("MyNFT", "MNFT") {}

    // ipfs://QmfNJZ6SrjeTnbpcRbSdJXPqbNW6VXBotgpgpFHfpaJigx
    function mint(address player, string memory tokenURI) public returns (uint256) {
        uint256 tokenId = _tokenId++;
        _mint(player, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }
}
