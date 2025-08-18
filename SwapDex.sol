// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract BaseSwap is ERC20, ReentrancyGuard {
    IERC20 public tokenA;
    IERC20 public tokenB;
    
    uint256 public reserveA;
    uint256 public reserveB;
    uint256 public constant FEE = 30; // 0.3% (30/10000)
    
    event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB, uint256 liquidity);
    event LiquidityRemoved(address indexed user, uint256 amountA, uint256 amountB, uint256 liquidity);
    event Swapped(address indexed user, address indexed tokenIn, uint256 amountIn, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) ERC20("BaseSwap LP Token", "BSLP") {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // Add liquidity to the pool
    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");
        
        uint256 liquidity;
        uint256 totalSupply = totalSupply();
        
        if (totalSupply == 0) {
            liquidity = sqrt(amountA * amountB);
        } else {
            liquidity = min(
                (amountA * totalSupply) / reserveA,
                (amountB * totalSupply) / reserveB
            );
        }
        
        require(liquidity > 0, "Insufficient liquidity minted");
        
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);
        
        _mint(msg.sender, liquidity);
        
        reserveA += amountA;
        reserveB += amountB;
        
        emit LiquidityAdded(msg.sender, amountA, amountB, liquidity);
    }

    // Remove liquidity from the pool
    function removeLiquidity(uint256 liquidity) external nonReentrant {
        require(liquidity > 0, "Liquidity must be greater than 0");
        
        uint256 totalSupply = totalSupply();
        uint256 amountA = (liquidity * reserveA) / totalSupply;
        uint256 amountB = (liquidity * reserveB) / totalSupply;
        
        _burn(msg.sender, liquidity);
        
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
        
        reserveA -= amountA;
        reserveB -= amountB;
        
        emit LiquidityRemoved(msg.sender, amountA, amountB, liquidity);
    }

    // Swap tokens
    function swap(address tokenIn, uint256 amountIn, uint256 minAmountOut) external nonReentrant {
        require(amountIn > 0, "Amount must be greater than 0");
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid token");
        
        bool isTokenA = tokenIn == address(tokenA);
        (IERC20 tokenOut, uint256 reserveIn, uint256 reserveOut) = isTokenA 
            ? (tokenB, reserveA, reserveB) 
            : (tokenA, reserveB, reserveA);
        
        // Transfer tokens in
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        
        // Calculate amount out with fee
        uint256 amountInWithFee = amountIn * (10000 - FEE);
        uint256 amountOut = (amountInWithFee * reserveOut) / (reserveIn * 10000 + amountInWithFee);
        
        require(amountOut >= minAmountOut, "Slippage too high");
        
        // Transfer tokens out
        tokenOut.transfer(msg.sender, amountOut);
        
        // Update reserves
        if (isTokenA) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }
        
        emit Swapped(msg.sender, tokenIn, amountIn, amountOut);
    }

    // Helper functions
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    
    // Get current price ratio
    function getPrice(address tokenIn, uint256 amountIn) external view returns (uint256) {
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid token");
        
        bool isTokenA = tokenIn == address(tokenA);
        uint256 reserveIn = isTokenA ? reserveA : reserveB;
        uint256 reserveOut = isTokenA ? reserveB : reserveA;
        
        uint256 amountInWithFee = amountIn * (10000 - FEE);
        return (amountInWithFee * reserveOut) / (reserveIn * 10000 + amountInWithFee);
    }
}