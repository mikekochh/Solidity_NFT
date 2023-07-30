// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;

    address public USER = makeAddr("Mike");

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    modifier mintNft() {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        _;
    }

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testInitialTokenBalanceIsZero() public {
        assertEq(basicNft.getTokenCounter(), 0);
    }

    function testTokenCounterIncreaseByOneWhenMinting() public mintNft {
        assertEq(basicNft.getTokenCounter(), 1);
    }

    function testTokenUriIsMappedCorrectly() public mintNft {
        string memory expectedTokenUri = PUG_URI;
        string memory actualTokenUri = basicNft.tokenURI(0);
        assertEq(
            keccak256(abi.encodePacked(expectedTokenUri)),
            keccak256(abi.encodePacked(actualTokenUri))
        );
    }

    function testNameIsCorrect() public {
        string memory expectedName = "Dawg";
        string memory actualName = basicNft.name();
        assertEq(
            keccak256(abi.encodePacked(expectedName)),
            keccak256(abi.encodePacked(actualName))
        );
    }

    // Patricks Tests
    function testHaveABalance() public mintNft {
        assert(basicNft.balanceOf(USER) == 1);
    }
}
