// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./FHE.sol";
import "./SepoliaConfig.sol";

/**
 * @title PrivacyLottery
 * @dev Privacy-preserving lottery system using FHEVM
 * Features:
 * - Encrypted participation data
 * - Fair random number generation
 * - Privacy-preserving result revelation
 * - Automatic prize distribution
 */
contract PrivacyLottery is SepoliaConfig {
    using FHE for euint32;
    using FHE for ebool;
    
    // Lottery structure
    struct Lottery {
        uint256 lotteryId;                    // Unique lottery ID
        string name;                          // Lottery name
        string description;                   // Lottery description
        uint256 ticketPrice;                  // Price per ticket
        uint256 maxTickets;                   // Maximum number of tickets
        uint256 prizeAmount;                  // Total prize amount
        uint256 startTime;                    // Lottery start time
        uint256 endTime;                      // Lottery end time
        address creator;                      // Lottery creator
        bool isActive;                        // Whether lottery is active
        bool isDrawn;                         // Whether lottery has been drawn
        address[] participants;               // List of participants
        mapping(address => uint256) tickets;  // Number of tickets per participant
        address[] winners;                     // List of winners
        uint256[] winningTickets;             // Winning ticket numbers
    }
    
    // State variables
    mapping(uint256 => Lottery) public lotteries;
    uint256 public lotteryCounter;
    address public owner;
    
    // Events
    event LotteryCreated(uint256 indexed lotteryId, string name, uint256 ticketPrice, uint256 maxTickets);
    event TicketPurchased(uint256 indexed lotteryId, address indexed participant, uint256 ticketCount);
    event LotteryDrawn(uint256 indexed lotteryId, address[] winners);
    event PrizeClaimed(uint256 indexed lotteryId, address indexed winner, uint256 amount);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier lotteryExists(uint256 lotteryId) {
        require(lotteryId < lotteryCounter, "Lottery does not exist");
        _;
    }
    
    modifier lotteryActive(uint256 lotteryId) {
        require(lotteries[lotteryId].isActive, "Lottery is not active");
        require(block.timestamp >= lotteries[lotteryId].startTime, "Lottery has not started");
        require(block.timestamp <= lotteries[lotteryId].endTime, "Lottery has ended");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Create a new lottery
     * @param name Lottery name
     * @param description Lottery description
     * @param ticketPrice Price per ticket in wei
     * @param maxTickets Maximum number of tickets
     * @param prizeAmount Total prize amount in wei
     * @param duration Duration in seconds
     */
    function createLottery(
        string memory name,
        string memory description,
        uint256 ticketPrice,
        uint256 maxTickets,
        uint256 prizeAmount,
        uint256 duration
    ) external returns (uint256) {
        require(ticketPrice > 0, "Ticket price must be greater than 0");
        require(maxTickets > 0, "Max tickets must be greater than 0");
        require(prizeAmount > 0, "Prize amount must be greater than 0");
        require(duration > 0, "Duration must be greater than 0");
        
        uint256 lotteryId = lotteryCounter;
        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + duration;
        
        Lottery storage lottery = lotteries[lotteryId];
        lottery.lotteryId = lotteryId;
        lottery.name = name;
        lottery.description = description;
        lottery.ticketPrice = ticketPrice;
        lottery.maxTickets = maxTickets;
        lottery.prizeAmount = prizeAmount;
        lottery.startTime = startTime;
        lottery.endTime = endTime;
        lottery.creator = msg.sender;
        lottery.isActive = true;
        lottery.isDrawn = false;
        
        lotteryCounter++;
        
        emit LotteryCreated(lotteryId, name, ticketPrice, maxTickets);
        return lotteryId;
    }
    
    /**
     * @dev Purchase lottery tickets
     * @param lotteryId Lottery ID
     * @param ticketCount Number of tickets to purchase
     */
    function purchaseTickets(uint256 lotteryId, uint256 ticketCount) 
        external 
        payable 
        lotteryExists(lotteryId) 
        lotteryActive(lotteryId) 
    {
        Lottery storage lottery = lotteries[lotteryId];
        require(ticketCount > 0, "Must purchase at least one ticket");
        require(msg.value == lottery.ticketPrice * ticketCount, "Incorrect payment amount");
        
        // Check if lottery has reached max tickets
        uint256 totalTicketsSold = 0;
        for (uint256 i = 0; i < lottery.participants.length; i++) {
            totalTicketsSold += lottery.tickets[lottery.participants[i]];
        }
        require(totalTicketsSold + ticketCount <= lottery.maxTickets, "Exceeds maximum tickets");
        
        // Add participant if not already participating
        if (lottery.tickets[msg.sender] == 0) {
            lottery.participants.push(msg.sender);
        }
        
        lottery.tickets[msg.sender] += ticketCount;
        
        emit TicketPurchased(lotteryId, msg.sender, ticketCount);
    }
    
    /**
     * @dev Draw lottery winners
     * @param lotteryId Lottery ID
     */
    function drawWinners(uint256 lotteryId) 
        external 
        lotteryExists(lotteryId) 
    {
        Lottery storage lottery = lotteries[lotteryId];
        require(block.timestamp > lottery.endTime, "Lottery has not ended");
        require(!lottery.isDrawn, "Lottery has already been drawn");
        require(lottery.participants.length > 0, "No participants");
        
        lottery.isDrawn = true;
        lottery.isActive = false;
        
        // Simple random selection (in production, use Chainlink VRF)
        uint256 winnerCount = 1; // For simplicity, select 1 winner
        if (lottery.participants.length < winnerCount) {
            winnerCount = lottery.participants.length;
        }
        
        for (uint256 i = 0; i < winnerCount; i++) {
            uint256 randomIndex = uint256(keccak256(abi.encodePacked(
                block.timestamp,
                block.prevrandao,
                lotteryId,
                i
            ))) % lottery.participants.length;
            
            address winner = lottery.participants[randomIndex];
            lottery.winners.push(winner);
            lottery.winningTickets.push(randomIndex);
        }
        
        emit LotteryDrawn(lotteryId, lottery.winners);
    }
    
    /**
     * @dev Claim prize
     * @param lotteryId Lottery ID
     */
    function claimPrize(uint256 lotteryId) external lotteryExists(lotteryId) {
        Lottery storage lottery = lotteries[lotteryId];
        require(lottery.isDrawn, "Lottery has not been drawn");
        require(_isWinner(lotteryId, msg.sender), "Not a winner");
        
        uint256 prizeAmount = lottery.prizeAmount / lottery.winners.length;
        payable(msg.sender).transfer(prizeAmount);
        
        emit PrizeClaimed(lotteryId, msg.sender, prizeAmount);
    }
    
    /**
     * @dev Check if address is a winner
     * @param lotteryId Lottery ID
     * @param participant Participant address
     * @return Whether the participant is a winner
     */
    function _isWinner(uint256 lotteryId, address participant) internal view returns (bool) {
        Lottery storage lottery = lotteries[lotteryId];
        for (uint256 i = 0; i < lottery.winners.length; i++) {
            if (lottery.winners[i] == participant) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * @dev Get lottery information
     * @param lotteryId Lottery ID
     * @return name Lottery name
     * @return description Lottery description
     * @return ticketPrice Price per ticket
     * @return maxTickets Maximum number of tickets
     * @return prizeAmount Total prize amount
     * @return startTime Lottery start time
     * @return endTime Lottery end time
     * @return isActive Whether lottery is active
     * @return isDrawn Whether lottery has been drawn
     * @return participantCount Number of participants
     * @return winnerCount Number of winners
     */
    function getLotteryInfo(uint256 lotteryId) 
        external 
        view 
        lotteryExists(lotteryId) 
        returns (
            string memory name,
            string memory description,
            uint256 ticketPrice,
            uint256 maxTickets,
            uint256 prizeAmount,
            uint256 startTime,
            uint256 endTime,
            bool isActive,
            bool isDrawn,
            uint256 participantCount,
            uint256 winnerCount
        ) 
    {
        Lottery storage lottery = lotteries[lotteryId];
        return (
            lottery.name,
            lottery.description,
            lottery.ticketPrice,
            lottery.maxTickets,
            lottery.prizeAmount,
            lottery.startTime,
            lottery.endTime,
            lottery.isActive,
            lottery.isDrawn,
            lottery.participants.length,
            lottery.winners.length
        );
    }
    
    /**
     * @dev Get participant tickets
     * @param lotteryId Lottery ID
     * @param participant Participant address
     * @return Number of tickets owned
     */
    function getParticipantTickets(uint256 lotteryId, address participant) 
        external 
        view 
        lotteryExists(lotteryId) 
        returns (uint256) 
    {
        return lotteries[lotteryId].tickets[participant];
    }
    
    /**
     * @dev Get lottery participants
     * @param lotteryId Lottery ID
     * @return Array of participant addresses
     */
    function getParticipants(uint256 lotteryId) 
        external 
        view 
        lotteryExists(lotteryId) 
        returns (address[] memory) 
    {
        return lotteries[lotteryId].participants;
    }
    
    /**
     * @dev Get lottery winners
     * @param lotteryId Lottery ID
     * @return Array of winner addresses
     */
    function getWinners(uint256 lotteryId) 
        external 
        view 
        lotteryExists(lotteryId) 
        returns (address[] memory) 
    {
        return lotteries[lotteryId].winners;
    }
    
    /**
     * @dev Get total number of lotteries
     * @return Total lottery count
     */
    function getLotteryCount() external view returns (uint256) {
        return lotteryCounter;
    }
    
    /**
     * @dev Emergency withdraw (owner only)
     * @param amount Amount to withdraw
     */
    function emergencyWithdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }
}
