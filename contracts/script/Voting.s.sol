// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Voting.sol";

contract DeployVoting is Script {
    function run() external {
        vm.startBroadcast();

        new Voting("TestVote", msg.sender);

        vm.stopBroadcast();
    }
}
