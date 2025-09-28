const fs = require('fs');
const path = require('path');

async function main() {
  console.log("🔄 Updating contract addresses...");
  
  // Read addresses.json
  const addressesPath = path.join(__dirname, '..', 'addresses.json');
  let addresses = {};
  
  try {
    if (fs.existsSync(addressesPath)) {
      addresses = JSON.parse(fs.readFileSync(addressesPath, 'utf8'));
    } else {
      console.log("❌ addresses.json not found. Please deploy contracts first.");
      return;
    }
  } catch (error) {
    console.log("❌ Error reading addresses.json:", error.message);
    return;
  }
  
  // Update frontend contracts.js
  const frontendContractsPath = path.join(__dirname, '..', '..', 'frontend', 'src', 'config', 'contracts.js');
  
  const contractsJsContent = `// Auto-generated contract addresses
// Generated at: ${new Date().toISOString()}

export const CONTRACT_ADDRESSES = {
  PrivacyLottery: "${addresses.PrivacyLottery || '0x0000000000000000000000000000000000000000'}",
};

export const NETWORK_CONFIG = {
  name: "Sepolia",
  chainId: 11155111,
  rpcUrl: "https://sepolia.infura.io/v3/YOUR_INFURA_KEY",
};

// Privacy Lottery ABI
export const PRIVACY_LOTTERY_ABI = [
  "function createLottery(string memory name, string memory description, uint256 ticketPrice, uint256 maxTickets, uint256 prizeAmount, uint256 duration) external returns (uint256)",
  "function purchaseTickets(uint256 lotteryId, uint256 ticketCount) external payable",
  "function drawWinners(uint256 lotteryId) external",
  "function claimPrize(uint256 lotteryId) external",
  "function getLotteryInfo(uint256 lotteryId) external view returns (string memory, string memory, uint256, uint256, uint256, uint256, uint256, bool, bool, uint256, uint256)",
  "function getParticipantTickets(uint256 lotteryId, address participant) external view returns (uint256)",
  "function getParticipants(uint256 lotteryId) external view returns (address[] memory)",
  "function getWinners(uint256 lotteryId) external view returns (address[] memory)",
  "function getLotteryCount() external view returns (uint256)",
  "function lotteries(uint256) external view returns (uint256, string memory, string memory, uint256, uint256, uint256, uint256, uint256, address, bool, bool)",
  "event LotteryCreated(uint256 indexed lotteryId, string name, uint256 ticketPrice, uint256 maxTickets)",
  "event TicketPurchased(uint256 indexed lotteryId, address indexed participant, uint256 ticketCount)",
  "event LotteryDrawn(uint256 indexed lotteryId, address[] winners)",
  "event PrizeClaimed(uint256 indexed lotteryId, address indexed winner, uint256 amount)"
];
`;

  try {
    // Ensure the directory exists
    const frontendConfigDir = path.dirname(frontendContractsPath);
    if (!fs.existsSync(frontendConfigDir)) {
      fs.mkdirSync(frontendConfigDir, { recursive: true });
    }
    
    fs.writeFileSync(frontendContractsPath, contractsJsContent);
    console.log("✅ Frontend contracts.js updated");
  } catch (error) {
    console.log("❌ Error updating frontend contracts.js:", error.message);
  }
  
  console.log("🎉 Address update completed!");
  console.log("Privacy Lottery Address:", addresses.PrivacyLottery);
  console.log("Network:", addresses.network || "sepolia");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Update failed:", error);
    process.exit(1);
  });
