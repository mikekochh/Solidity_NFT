// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract MoodNftTest is Test {
    error MoodNft__CantFlipMoodIfNotOwner();

    MoodNft moodNft;
    string public constant HAPPY_SVG_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI2MSIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgo8L3N2Zz4=";
    string public constant SAD_SVG_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8c3ZnIHdpZHRoPSIxMDI0cHgiIGhlaWdodD0iMTAyNHB4IiB2aWV3Qm94PSIwIDAgMTAyNCAxMDI0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogICAgPHBhdGggZmlsbD0iIzMzMyIKICAgICAgICBkPSJNNTEyIDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYgNDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcyczE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIgLz4KICAgIDxwYXRoIGZpbGw9IiNFNkU2RTYiCiAgICAgICAgZD0iTTUxMiAxNDBjLTIwNS40IDAtMzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4wMSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYzNi4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcuNC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUxLjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDguMDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIgLz4KICAgIDxwYXRoIGZpbGw9IiMzMzMiCiAgICAgICAgZD0iTTI4OCA0MjFhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAwem0yMjQgMTEyYy04NS41IDAtMTU1LjYgNjcuMy0xNjAgMTUxLjZhOCA4IDAgMCAwIDggOC40aDQ4LjFjNC4yIDAgNy44LTMuMiA4LjEtNy40IDMuNy00OS41IDQ1LjMtODguNiA5NS44LTg4LjZzOTIgMzkuMSA5NS44IDg4LjZjLjMgNC4yIDMuOSA3LjQgOC4xIDcuNEg2NjRhOCA4IDAgMCAwIDgtOC40QzY2Ny42IDYwMC4zIDU5Ny41IDUzMyA1MTIgNTMzem0xMjgtMTEyYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHoiIC8+Cjwvc3ZnPg==";
    string public constant BASE_URI = "data:application/json;base64,";

    address USER = makeAddr("user");

    modifier flipMood() {
        vm.prank(USER);
        moodNft.flipMood(0);
        _;
    }

    function setUp() public {
        moodNft = new MoodNft(SAD_SVG_URI, HAPPY_SVG_URI);
        vm.prank(USER);
        moodNft.mintNft();
    }

    function testViewTokenURI() public view {
        console.log(moodNft.tokenURI(0));
    }

    function testFlipMoonRevertIfNotOwner() public {
        vm.expectRevert(MoodNft__CantFlipMoodIfNotOwner.selector);
        moodNft.flipMood(0);
    }

    function testFlipMood() public flipMood {
        assert(moodNft.getTokenIdToMood(0) == MoodNft.Mood.SAD);
    }

    function testDoubleFlipMood() public flipMood flipMood {
        assert(moodNft.getTokenIdToMood(0) == MoodNft.Mood.HAPPY);
    }

    function testTokenCounter() public view {
        assert(moodNft.getTokenCounter() == 1);
    }

    function testRevertIfBadUserTryToMintNFT() public {
        vm.expectRevert();
        moodNft.mintNft();
    }
}
