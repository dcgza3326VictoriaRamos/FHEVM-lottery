# 🚀 FHEVM Privacy Lottery Deployment Guide

This guide will help you deploy the FHEVM Privacy Lottery system to various platforms.

## 📋 Prerequisites

- Node.js 18+ installed
- MetaMask wallet with Sepolia testnet ETH
- GitHub account (for GitHub Pages deployment)
- Environment variables configured

## 🔧 Environment Setup

### 1. Install Dependencies

```bash
# Install root dependencies
npm install

# Install example dependencies
cd example && npm install

# Install frontend dependencies
cd ../frontend && npm install
```

### 2. Configure Environment Variables

```bash
# Copy environment template
cp example/env.example example/.env

# Edit .env file with your values
PRIVATE_KEY=your_private_key_here
SEPOLIA_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
ETHERSCAN_API_KEY=your_etherscan_api_key_here
```

## 🏗️ Smart Contract Deployment

### 1. Compile Contracts

```bash
cd example
npm run compile
```

### 2. Deploy to Sepolia

```bash
# Deploy lottery contract
npm run deploy:lottery

# Update contract addresses
npm run addresses
```

### 3. Verify Contracts (Optional)

```bash
# Verify on Etherscan
npm run verify:all
```

## 🌐 Frontend Deployment

### Option 1: GitHub Pages (Recommended)

#### Quick Deployment

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

#### Manual GitHub Pages Setup

1. **Create GitHub Repository**
   ```bash
   git init
   git remote add origin https://github.com/YOUR_USERNAME/FHEVM-Privacy-Lottery.git
   ```

2. **Configure GitHub Pages**
   - Go to repository Settings
   - Navigate to Pages section
   - Select "Deploy from a branch"
   - Choose `gh-pages` branch
   - Save settings

3. **Deploy Frontend**
   ```bash
   # Build frontend
   npm run frontend:build
   
   # Create gh-pages branch
   git checkout -b gh-pages
   
   # Copy build files to root
   cp -r frontend/build/* .
   
   # Commit and push
   git add .
   git commit -m "Deploy FHEVM Privacy Lottery"
   git push origin gh-pages
   ```

### Option 2: Vercel Deployment

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Deploy**
   ```bash
   cd frontend
   vercel --prod
   ```

3. **Configure Environment Variables**
   - Add contract addresses in Vercel dashboard
   - Update `frontend/src/config/contracts.js`

### Option 3: Netlify Deployment

1. **Build Frontend**
   ```bash
   npm run frontend:build
   ```

2. **Deploy to Netlify**
   - Drag and drop `frontend/build` folder to Netlify
   - Or connect GitHub repository for automatic deployments

## 🔗 Network Configuration

### Sepolia Testnet

- **Network Name**: Sepolia Testnet
- **RPC URL**: https://sepolia.infura.io/v3/YOUR_INFURA_KEY
- **Chain ID**: 11155111
- **Currency Symbol**: ETH
- **Block Explorer**: https://sepolia.etherscan.io

### Zama Network (Optional)

- **Network Name**: Zama FHEVM
- **RPC URL**: https://devnet.zama.ai
- **Chain ID**: 8009
- **Currency Symbol**: ZAMA

## 🛠️ Development Deployment

### Local Development

```bash
# Start development server
npm run frontend:start

# Access at http://localhost:3000
```

### Testnet Deployment

```bash
# Deploy to Sepolia
cd example
npm run deploy:lottery

# Start frontend
cd ../frontend
npm start
```

## 📱 Mobile Deployment

### PWA Configuration

The application is configured as a Progressive Web App (PWA) with:

- **Service Worker**: Automatic caching
- **Offline Support**: Basic offline functionality
- **Mobile Optimized**: Responsive design
- **App-like Experience**: Full-screen mode

### Mobile Testing

1. **Chrome DevTools**
   - Open DevTools (F12)
   - Toggle device toolbar
   - Test on various device sizes

2. **Real Device Testing**
   - Deploy to GitHub Pages
   - Access from mobile browser
   - Test MetaMask mobile app integration

## 🔒 Security Considerations

### Environment Variables

- **Never commit `.env` files**
- **Use environment-specific configurations**
- **Rotate keys regularly**

### Smart Contract Security

- **Audit contracts before mainnet deployment**
- **Use multi-signature wallets for admin functions**
- **Implement proper access controls**

### Frontend Security

- **Validate all user inputs**
- **Use HTTPS in production**
- **Implement proper error handling**

## 🐛 Troubleshooting

### Common Issues

1. **Contract Deployment Fails**
   ```bash
   # Check environment variables
   cat example/.env
   
   # Verify network connection
   npm run compile
   ```

2. **Frontend Build Fails**
   ```bash
   # Clear cache and reinstall
   cd frontend
   rm -rf node_modules package-lock.json
   npm install
   npm run build
   ```

3. **GitHub Pages Blank Page**
   ```bash
   # Check build output
   ls -la frontend/build/
   
   # Verify index.html exists
   cat frontend/build/index.html
   ```

### Debug Commands

```bash
# Check contract deployment
cd example
npm run addresses

# Verify frontend build
cd frontend
npm run build
ls -la build/

# Test local deployment
npm run frontend:start
```

## 📊 Monitoring and Analytics

### Contract Monitoring

- **Etherscan verification**: Verify deployed contracts
- **Event monitoring**: Track lottery events
- **Gas optimization**: Monitor gas usage

### Frontend Analytics

- **User interactions**: Track lottery participation
- **Performance metrics**: Monitor loading times
- **Error tracking**: Log and analyze errors

## 🔄 Continuous Deployment

### GitHub Actions (Optional)

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
      - name: Install dependencies
        run: |
          npm install
          cd frontend && npm install
      - name: Build frontend
        run: cd frontend && npm run build
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./frontend/build
```

## 📞 Support

### Getting Help

- **Documentation**: Check this guide and README.md
- **Issues**: Create GitHub issues for bugs
- **Discussions**: Use GitHub discussions for questions

### Community

- **Zama Discord**: Join the Zama community
- **GitHub Discussions**: Ask questions and share ideas
- **Stack Overflow**: Tag questions with `fhevm` and `zama`

## 🎉 Success!

Once deployed, your FHEVM Privacy Lottery will be available at:

- **GitHub Pages**: `https://YOUR_USERNAME.github.io/FHEVM-Privacy-Lottery`
- **Vercel**: `https://YOUR_PROJECT.vercel.app`
- **Netlify**: `https://YOUR_SITE.netlify.app`

Users can now:
- Connect their MetaMask wallets
- Create and participate in lotteries
- Experience privacy-preserving lottery functionality
- Enjoy the modern, responsive UI

Happy deploying! 🚀
