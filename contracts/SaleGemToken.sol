// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./MintGemToken.sol";

contract SaleGemToken {
  MintGemToken public mintGemToken;

  constructor(address _mintGemToken) {
    mintGemToken = MintGemToken(_mintGemToken);
  }

  mapping (uint256 => uint256) public tokenPricesById;

  uint256[] public onSaleTokens;

  function setForSaleGemToken(uint256 _tokenId, uint256 _price) public {
    address tokenOwner = mintGemToken.ownerOf(_tokenId);
    
    require(tokenOwner == msg.sender, "Invalid Owner Address");
    require(_price > 0, "The price must be greater than 0");
    require(tokenPricesById[_tokenId] == 0, "Token is already on sale");
    require(mintGemToken.isApprovedForAll(msg.sender, address(this)), "Operator was not approved");

    tokenPricesById[_tokenId] = _price;

    onSaleTokens.push(_tokenId);
  }
}
