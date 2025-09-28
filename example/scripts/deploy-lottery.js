const { ethers } = require("hardhat");

async function main() {
  console.log("🎲 Deploying Privacy Lottery Contract...");
  
  // Get the contract factory
  const PrivacyLottery = await ethers.getContractFactory("PrivacyLottery");
  
  // Deploy the contract
  const lottery = await PrivacyLottery.deploy();
  await lottery.waitForDeployment();
  
  const lotteryAddress = await lottery.getAddress();
  console.log("✅ Privacy Lottery deployed to:", lotteryAddress);
  
  // Save the address to addresses.json
  const fs = require('fs');
  const path = require('path');
  
  let addresses = {};
  const addressesPath = path.join(__dirname, '..', 'addresses.json');
  
  try {
    if (fs.existsSync(addressesPath)) {
      addresses = JSON.parse(fs.readFileSync(addressesPath, 'utf8'));
    }
  } catch (error) {
    console.log("Creating new addresses.json file");
  }
  
  addresses.PrivacyLottery = lotteryAddress;
  addresses.network = "sepolia";
  addresses.timestamp = new Date().toISOString();
  
  fs.writeFileSync(addressesPath, JSON.stringify(addresses, null, 2));
  console.log("📝 Contract address saved to addresses.json");
  
  console.log("\n🎉 Deployment completed successfully!");
  console.log("Contract Address:", lotteryAddress);
  console.log("Network: Sepolia");
  console.log("Next steps:");
  console.log("1. Update frontend configuration");
  console.log("2. Start the frontend application");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
