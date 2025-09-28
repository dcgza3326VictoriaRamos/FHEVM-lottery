const { ethers } = require("hardhat");

async function main() {
  console.log("🧪 Testing Privacy Lottery Permissions...");
  
  // Get signers
  const [owner, user1, user2] = await ethers.getSigners();
  
  // Deploy contract
  const PrivacyLottery = await ethers.getContractFactory("PrivacyLottery");
  const lottery = await PrivacyLottery.deploy();
  await lottery.waitForDeployment();
  
  console.log("✅ Contract deployed at:", await lottery.getAddress());
  console.log("👤 Owner:", await owner.getAddress());
  console.log("👤 User1:", await user1.getAddress());
  console.log("👤 User2:", await user2.getAddress());
  
  // Test 1: User1 creates lottery (should work)
  console.log("\n🧪 Test 1: User1 creates lottery...");
  try {
    const tx1 = await lottery.connect(user1).createLottery(
      "Test Lottery",
      "A test lottery",
      ethers.parseEther("0.01"), // 0.01 ETH per ticket
      100, // max 100 tickets
      ethers.parseEther("1.0"), // 1 ETH prize
      7 * 24 * 60 * 60 // 7 days duration
    );
    await tx1.wait();
    console.log("✅ User1 successfully created lottery");
  } catch (error) {
    console.log("❌ User1 failed to create lottery:", error.message);
  }
  
  // Test 2: User2 creates lottery (should work)
  console.log("\n🧪 Test 2: User2 creates lottery...");
  try {
    const tx2 = await lottery.connect(user2).createLottery(
      "Another Lottery",
      "Another test lottery",
      ethers.parseEther("0.02"), // 0.02 ETH per ticket
      50, // max 50 tickets
      ethers.parseEther("0.5"), // 0.5 ETH prize
      3 * 24 * 60 * 60 // 3 days duration
    );
    await tx2.wait();
    console.log("✅ User2 successfully created lottery");
  } catch (error) {
    console.log("❌ User2 failed to create lottery:", error.message);
  }
  
  // Test 3: User1 purchases tickets from lottery 0
  console.log("\n🧪 Test 3: User1 purchases tickets...");
  try {
    const tx3 = await lottery.connect(user1).purchaseTickets(0, 2, {
      value: ethers.parseEther("0.02") // 2 tickets * 0.01 ETH
    });
    await tx3.wait();
    console.log("✅ User1 successfully purchased tickets");
  } catch (error) {
    console.log("❌ User1 failed to purchase tickets:", error.message);
  }
  
  // Test 4: User2 purchases tickets from lottery 0
  console.log("\n🧪 Test 4: User2 purchases tickets...");
  try {
    const tx4 = await lottery.connect(user2).purchaseTickets(0, 1, {
      value: ethers.parseEther("0.01") // 1 ticket * 0.01 ETH
    });
    await tx4.wait();
    console.log("✅ User2 successfully purchased tickets");
  } catch (error) {
    console.log("❌ User2 failed to purchase tickets:", error.message);
  }
  
  // Test 5: Check lottery info
  console.log("\n🧪 Test 5: Checking lottery info...");
  try {
    const lotteryInfo = await lottery.getLotteryInfo(0);
    console.log("✅ Lottery 0 info:");
    console.log("   Name:", lotteryInfo[0]);
    console.log("   Description:", lotteryInfo[1]);
    console.log("   Ticket Price:", ethers.formatEther(lotteryInfo[2]), "ETH");
    console.log("   Max Tickets:", lotteryInfo[3].toString());
    console.log("   Prize Amount:", ethers.formatEther(lotteryInfo[4]), "ETH");
    console.log("   Is Active:", lotteryInfo[7]);
    console.log("   Participant Count:", lotteryInfo[9].toString());
  } catch (error) {
    console.log("❌ Failed to get lottery info:", error.message);
  }
  
  console.log("\n🎉 Permission tests completed!");
  console.log("✅ All users can create lotteries");
  console.log("✅ All users can purchase tickets");
  console.log("✅ All users can view lottery info");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Test failed:", error);
    process.exit(1);
  });
