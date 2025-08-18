# SwapDex - Decentralized Exchange on Base Blockchain

## Table of Contents
- [Introduction](#-introduction)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Smart Contracts](#-smart-contracts)
- [Frontend](#-frontend)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

## 🌟 Introduction

SwapDex is a decentralized automated market maker (AMM) built on Base Blockchain, enabling users to:
- Swap ERC-20 tokens trustlessly
- Provide liquidity and earn trading fees
- Participate in decentralized finance with low gas costs

## ✨ Features

- **Gas-efficient swaps** optimized for Base L2
- **0.3% trading fee** distributed to liquidity providers
- **Liquidity pool management** (add/remove liquidity)
- **Slippage protection** for secure trading
- **LP tokens** representing pool shares
- **Responsive UI** with wallet integration

## 🛠 Tech Stack

### Smart Contracts
- Solidity (0.8.0+)
- Hardhat (development framework)
- OpenZeppelin Contracts (security standards)
- Ethers.js (Web3 interactions)

### Frontend
- React.js (v18+)
- Vite (build tool)
- Ethers.js (blockchain interactions)
- Chakra UI (component library)
- Wagmi (React hooks for Web3)

## 🚀 Getting Started

### Prerequisites
- Node.js (v16+)
- npm or yarn
- MetaMask or Coinbase Wallet
- Base-compatible RPC URL

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/swapdex.git
cd swapdex
```

2. Install contract dependencies:
```bash
cd contracts
npm install
```

3. Install frontend dependencies:
```bash
cd ../frontend
npm install
```

4. Set up environment variables:
```bash
cp .env.example .env
```
Fill in your environment variables in the `.env` file.

## 📜 Smart Contracts

### Contract Structure
- `SwapDex.sol`: Main AMM contract with swap and liquidity functionality
- `IERC20.sol`: Interface for ERC-20 tokens
- `ERC20.sol`: Standard token implementation

### Compile Contracts
```bash
cd contracts
npx hardhat compile
```

### Run Tests
```bash
npx hardhat test
```

## 💻 Frontend

### Available Scripts
- `npm run dev`: Start development server
- `npm run build`: Create production build
- `npm run preview`: Preview production build

### Key Components
- `SwapInterface`: Token swap functionality
- `PoolManager`: Liquidity pool management
- `WalletConnector`: Web3 wallet integration
- `TokenSelector`: Token dropdown selector

## 🌐 Deployment

### Deploy to Base Testnet
1. Configure your Hardhat config with Base testnet settings
2. Run deployment script:
```bash
npx hardhat run scripts/deploy.js --network base-testnet
```

### Verify Contracts
```bash
npx hardhat verify --network base-testnet <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Useful Links

- [Base Blockchain Documentation](https://docs.base.org)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Ethers.js Documentation](https://docs.ethers.org/v5/)
- [Chakra UI Documentation](https://chakra-ui.com/docs)

---

Made with ❤️ for the Base ecosystem
