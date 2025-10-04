# 🎲 FHEVM Privacy Lottery System

A privacy-preserving lottery system using Zama's Fully Homomorphic Encryption (FHE) technology.

**🎮 Interactive Learning** - Learn FHEVM technology through lottery system deployment and testing

## ✨ Features

- 🔐 **Real FHEVM Integration**: Using `@fhevm/solidity` and `@zama-fhe/relayer-sdk`
- 🎲 **Privacy Lottery**: All lottery data is encrypted using FHE
- 🎯 **Fair Drawing**: Cryptographically secure random number generation
- 🌐 **Sepolia Testnet**: Configured and supports Sepolia deployment
- ⚡ **Modern React UI**: Beautiful interface using Tailwind CSS
- 🛡️ **Secure Lottery**: Prevents manipulation and ensures fairness

## 🏗️ Project Structure

```
zama/
├── example/                    # Example contracts
│   ├── contracts/
│   │   ├── FHE.sol            # FHE library
│   │   ├── PrivacyLottery.sol # FHEVM privacy lottery contract
│   │   └── SepoliaConfig.sol  # Sepolia configuration
│   ├── scripts/
│   │   ├── deploy-lottery.js  # Deployment script
│   │   └── update-addresses.js # Address management script
│   ├── hardhat.config.cjs    # Hardhat configuration
│   └── package.json           # Example dependencies
├── frontend/                   # React frontend
│   ├── src/
│   │   ├── App.jsx            # Main React application
│   │   ├── fheClient.js       # FHEVM client wrapper
│   │   ├── config/
│   │   │   └── contracts.js   # Contract configuration
│   │   ├── index.js           # React entry point
│   │   └── index.css          # Tailwind CSS styles
│   └── package.json           # Frontend dependencies
├── package.json               # Project dependencies
└── README.md                  # Project documentation
```

## 🎨 UI Design Features

### Modern Glass-Morphism Design
- **Dark Theme**: Sleek dark background with gradient overlays
- **Glass Effects**: Backdrop blur and transparency for modern look
- **Gradient Buttons**: Beautiful gradient buttons with hover animations
- **Status Indicators**: Color-coded status badges with animations
- **Responsive Cards**: Grid layout that adapts to all screen sizes

### Interactive Elements
- **Hover Effects**: Smooth scale and shadow transitions
- **Loading States**: Animated spinners and skeleton screens
- **Status Badges**: Dynamic status indicators for lottery states
- **Progress Bars**: Visual progress indicators for lottery phases

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install root dependencies
npm install

# Install example dependencies
cd example && npm install

# Install frontend dependencies
cd ../frontend && npm install
```

### 2. Configure Environment

```bash
# Copy environment template
cp example/env.example example/.env

# Edit .env file with your values:
# - PRIVATE_KEY: Your wallet private key
# - SEPOLIA_URL: Sepolia RPC URL (Infura, Alchemy, etc.)
# - ETHERSCAN_API_KEY: Etherscan API key for verification
```

### 3. Deploy Contracts

```bash
# Deploy lottery contract
npm run deploy:lottery

# Update address configuration
npm run addresses
```

### 4. Start Frontend

```bash
npm run frontend:start
```

The application will open at `http://localhost:3000`.

## 🎲 Lottery System Features

### Core Functionality
- **Create Lottery**: Admin can create new lottery events
- **Join Lottery**: Users can participate in active lotteries
- **Fair Drawing**: Cryptographically secure random selection
- **Prize Distribution**: Automatic prize distribution to winners
- **Privacy Protection**: All participation data encrypted using FHE

### Privacy Features
- **Encrypted Participation**: User participation data is encrypted
- **Homomorphic Operations**: Secure computation on encrypted data
- **Result Revelation**: Fair and transparent result disclosure
- **Data Protection**: No sensitive data exposure during processing

## 🛠️ Development

### Smart Contract Development
```bash
# Compile contracts
npm run compile

# Run tests
cd example && npm test

# Deploy to Sepolia
npm run deploy:lottery
```

### Frontend Development
```bash
# Start development server
npm run frontend:start

# Build for production
npm run frontend:build
```

## 🔧 Configuration

### Network Configuration
- **Sepolia Testnet**: Default test network
- **Zama Network**: FHEVM test network support
- **Custom Networks**: Easy configuration for other networks

### Contract Addresses
Contract addresses are automatically managed in `example/addresses.json` and synchronized with the frontend.

## 🎯 Usage

### For Users
1. **Connect Wallet**: Connect your MetaMask wallet
2. **Create Lottery**: Anyone can create new lottery events
3. **Browse Lotteries**: View all available lottery events
4. **Participate**: Purchase tickets for lotteries you're interested in
5. **Draw Winners**: Anyone can draw winners when lottery ends
6. **Check Results**: View lottery results and claim prizes
7. **Claim Prizes**: Winners can claim their prizes automatically

## 🔒 Security Features

- **FHEVM Integration**: Full homomorphic encryption support
- **Fair Randomness**: Cryptographically secure random number generation
- **Privacy Protection**: Encrypted data processing
- **Access Control**: Role-based permissions
- **Audit Trail**: Complete transaction history

## 🌐 Deployment

### GitHub Pages Deployment
```bash
# Build frontend
npm run frontend:build

# Deploy to GitHub Pages
cd frontend/build
git init
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git add .
git commit -m "Deploy FHEVM Privacy Lottery"
git branch -M gh-pages
git push -f origin gh-pages
```

## 📚 Documentation

- [FHEVM Documentation](https://docs.zama.ai/)
- [Zama FHEVM Examples](https://github.com/zama-ai/fhevm)
- [Hardhat Documentation](https://hardhat.org/docs)

## 🐛 Troubleshooting

### Common Issues
- **Connection Issues**: Ensure MetaMask is connected to Sepolia
- **Contract Errors**: Verify contract deployment and addresses
- **FHEVM Issues**: Check FHEVM client initialization

### Support
- Check Zama documentation: https://docs.zama.ai/
- Check official relayer SDK documentation
- Ensure all dependencies are properly installed

## 📄 License

MIT License - See LICENSE file for details.

## ⚠️ Disclaimer

This is a demonstration project. Use at your own risk, ensure proper security measures before any production deployment.

## 🙏 Acknowledgments

- Using [Zama FHEVM technology](https://github.com/zama-ai/fhevm)
- Based on [OpenZeppelin contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Inspired by fair lottery system research
