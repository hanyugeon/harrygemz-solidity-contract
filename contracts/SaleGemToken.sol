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

  function purchaseGemToken(uint256 _tokenId) public payable {
    address tokenOwner = mintGemToken.ownerOf(_tokenId);

    require(tokenPricesById[_tokenId] > 0, "Token is not on sale");
    require(tokenPricesById[_tokenId] <= msg.value, "Can't buy it at a lower price");
    require(tokenOwner != msg.sender, "owner cant buy it selves");

    payable(tokenOwner).transfer(msg.value);

    // safeTransferFrom(): from이 tokenId를 소유해야함, to는 보낼사람, tokenId는 해당 말 그대로 tokenId
    mintGemToken.safeTransferFrom(tokenOwner, msg.sender, _tokenId);

    tokenPricesById[_tokenId] = 0;

    popOnSaleToken(_tokenId);
  }

  function popOnSaleToken(uint256 _tokenId) private {
    for (uint256 i = 0; i < onSaleTokens.length; i++) {
      if (onSaleTokens[i] == _tokenId) {
        onSaleTokens[i] = onSaleTokens[onSaleTokens.length - 1];
        onSaleTokens.pop();
      }
    }
  }
}
