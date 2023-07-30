// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageURI = sadSvgImageUri;
        s_happySvgImageURI = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    // Base64 util allows you to transform bytes32 data into its Base64 string representation.
    // were first going to make our metadata json object, and then we're going to use openzeppelin to convert this Json object into Json tokenURI
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageURI;
        } else {
            imageURI = s_sadSvgImageURI;
        }

        // this is equivalent to getting the giant text string that we got from running the base64 terminal command
        Base64.encode(
            bytes(
                abi.encodePacked(
                    '{"name":"',
                    name(), // You can add whatever name here
                    '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                    '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                    imageURI,
                    '"}'
                )
            )
        );
    }
}
