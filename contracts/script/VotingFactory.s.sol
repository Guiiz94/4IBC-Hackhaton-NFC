// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/VotingFactory.sol";

contract DeployVotingFactoryScript is Script {
    function run() external {
        vm.startBroadcast();

        new VotingFactory();

        vm.stopBroadcast();
    }
}