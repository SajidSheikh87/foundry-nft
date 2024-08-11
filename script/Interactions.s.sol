// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MintBasicNft is Script {
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );
        console.log(
            "Most recently deployed MoodNft address:",
            mostRecentlyDeployed
        );
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );
        console.log(
            "Most recently deployed MoodNft address:",
            mostRecentlyDeployed
        );
        mintMoodNft(mostRecentlyDeployed);
    }

    function mintMoodNft(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );
        console.log(
            "Most recently deployed MoodNft address:",
            mostRecentlyDeployed
        );
        flipMood(mostRecentlyDeployed);
    }

    function flipMood(address contracAddress) public {
        uint256 latestToken = MoodNft(contracAddress).getTotalTokensCount();
        // string memory oldMood = MoodNft(contracAddress).getMood(latestToken);
        address tokenOwner = MoodNft(contracAddress).ownerOf(latestToken);
        vm.startBroadcast();
        console.log("Token Number: ", latestToken);
        console.log("Token Owner: ", tokenOwner);
        console.log("Mood Flip called by: ", msg.sender);
        console.log("Old Mood: ", MoodNft(contracAddress).getMood(latestToken));
        MoodNft(contracAddress).flipMood(latestToken);
        console.log("New Mood: ", MoodNft(contracAddress).getMood(latestToken));
        vm.stopBroadcast();
    }
}
