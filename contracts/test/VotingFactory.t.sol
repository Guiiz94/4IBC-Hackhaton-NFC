// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingFactory.sol";
import "../src/Voting.sol";

contract VotingFactoryTest is Test {
    VotingFactory private votingFactory;

    function setUp() public {
        votingFactory = new VotingFactory();
    }

    function testDeployVotingContract() public {
        string memory voteName = "Test Vote";
        string[] memory wl = new string[](2);
        wl[0] = "NFC123";
        wl[1] = "NFC456";
        
        address expectedOwner = msg.sender;
        
        address votingAddress = votingFactory.createVoting(voteName, expectedOwner, wl);
        assertTrue(votingAddress != address(0), "Voting contract address should not be zero");
        
        Voting voting = Voting(votingAddress);
        address actualOwner = voting.owner();
        assertEq(actualOwner, expectedOwner, "The owner of the Voting contract does not match the expected owner");
    }

}
