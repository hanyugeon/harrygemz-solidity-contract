// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // toString() 사용가능 (uint256를 ASCII string 으로 형변환)
import "@openzeppelin/contracts/access/Ownable.sol";  // Ownable을 통한 소유권 부여

contract MintGemToken is ERC721Enumerable, Ownable {
  string public metadataURI;

  constructor(string memory _name, string memory _symbol, string memory _metadataURI) ERC721(_name, _symbol) {
    metadataURI = _metadataURI;
  }

  struct GemTokenData {
    uint256 gemTokenRank;
    uint256 gemTokenType;
  }

  mapping(uint256 => GemTokenData) public tokenDataById;

  function tokenURI(uint256 _tokenId) override public view returns (string memory) {
    string memory gemTokenRank = Strings.toString(tokenDataById[_tokenId].gemTokenRank);
    string memory gemTokenType = Strings.toString(tokenDataById[_tokenId].gemTokenType);

    return string(abi.encodePacked(metadataURI, '/', gemTokenRank, '/', gemTokenType, '.json')); 
  }

  function mintGemToken() public  {
    uint256 tokenId = totalSupply() + 1;

    GemTokenData memory randomTokenData = randomGenerater(msg.sender, tokenId);

    tokenDataById[tokenId] = GemTokenData(randomTokenData.gemTokenRank, randomTokenData.gemTokenType);

    _mint(msg.sender, tokenId);
  }

  function randomGenerater(address _msgSender, uint256 _tokenId) private view returns (GemTokenData memory) {
    uint256 randomNum = uint256(keccak256(abi.encodePacked(blockhash(block.timestamp), _msgSender, _tokenId))) % 100;

    GemTokenData memory randomTokenData;

    if (randomNum < 5) {
      if (randomNum == 1) {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum == 2) {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum == 3) {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 4;
      }
    } else if (randomNum < 13) {
      if (randomNum < 7) {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum < 9) {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum < 11) {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 4;
      }
    } else if (randomNum < 37) {
      if (randomNum < 19) {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum < 25) {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum < 31) {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 4;
      }
    } else {
      if (randomNum < 52) {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum < 68) {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum < 84) {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 4;
      }
    }

    return randomTokenData;
  }
}
