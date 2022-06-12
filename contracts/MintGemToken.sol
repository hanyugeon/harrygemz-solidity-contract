// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // toString() 사용가능 (uint256를 ASCII string 으로 형변환)

contract MintGemToken is ERC721Enumerable {
  string public metadataURI;

  constructor(string memory _name, string memory _symbol, string memory _metadataURI) ERC721(_name, _symbol) {
    metadataURI = _metadataURI;
  }

  struct GemTokenData {
    uint256 gemTokenRank;
    uint256 gemTokenType;
  }

  mapping(uint256 => GemTokenData) public _tokenDataById;

  function tokenURI(uint256 _tokenId) override public view returns (string memory) {
    string memory gemTokenRank = Strings.toString(_tokenDataById[_tokenId].gemTokenRank);
    string memory gemTokenType = Strings.toString(_tokenDataById[_tokenId].gemTokenType);

    return string(abi.encodePacked(metadataURI, '/', gemTokenRank, '/', gemTokenType, '.json')); 
  }

  function mintGemToken() public  {
    uint256 tokenId = totalSupply() + 1;

    _tokenDataById[tokenId] = GemTokenData(1, 1);

    _mint(msg.sender, tokenId);
  }
}
