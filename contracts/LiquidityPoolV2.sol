//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Prime3 is ERC20 {

    constructor () ERC20("Prime1", "P1") {
        _mint(msg.sender, 10000 ether);
    }

}

contract Prime4 is ERC20 {
    constructor () ERC20("Prime2", "P2") {
        _mint(msg.sender, 5000 ether);
    }
}

contract Pool3 {
    IERC20 public token0;
    IERC20 public token1;
    address private owner;

    uint256 public k;
    uint256 public reserve0;
    uint256 public reserve1;

    mapping (uint => mapping (address => uint)) public balances;

    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'UniswapV2: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    event Transfer(address indexed from, address indexed to, uint value);

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
        owner = msg.sender;
    }

    function initialize(uint256 _amount0, uint256 _amount1) external {
        require(token0.allowance(msg.sender, address(this)) >= _amount0 && 
        token1.allowance(msg.sender, address(this)) >= _amount1, "Insufficient allowance");
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        balances[1][msg.sender] = token0.balanceOf(msg.sender);
        balances[2][msg.sender] = token1.balanceOf(msg.sender);

        reserve0 += _amount0;
        reserve1 += _amount1;

        if(k == 0) {
           k = _amount0 * _amount1;
        }
    }

    function swap(uint256 _amount0Out, uint256 _amount1Out) external lock {
        require(owner == msg.sender, "Not owner");
        require(_amount0Out > 0 || _amount1Out > 0, "Insufficient input");
        require(k > 0, "no liquidity");
       

        if (_amount0Out > 0) {
            uint _amount1In = reserve1 - k/(reserve0 + _amount0Out);
             k = (reserve1 + _amount1In) * (reserve0 - _amount0Out);

            reserve1 += _amount1In;
            reserve0 -= _amount0Out;

            balances[2][msg.sender] -= _amount1In;
            balances[1][msg.sender] -= _amount0Out;

            token1.transferFrom(msg.sender, address(this), _amount1In);
            token0.transfer(msg.sender, _amount0Out);
            emit Transfer(address(this), msg.sender, _amount0Out);

        } else if (_amount1Out > 0) {
            uint _amount0In = reserve1 - k/(reserve0 + _amount1Out);
             k = (reserve0 + _amount0In) * (reserve1 - _amount1Out);

            reserve0 += _amount0In;
            reserve1 -= _amount1Out;

            balances[2][msg.sender] -= _amount0In;
            balances[1][msg.sender] -= _amount1Out;

            token0.transferFrom(msg.sender, address(this), _amount0In);
            token1.transfer(msg.sender, _amount1Out);
            emit Transfer(address(this), msg.sender, _amount1Out);
        }

        
    }

}

contract Pool4 {
    IERC20 public token0;
    IERC20 public token1;
    address private owner;

    uint256 public k;
    uint256 public reserve0;
    uint256 public reserve1;

    mapping (uint => mapping (address => uint)) public balances;

    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'UniswapV2: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    event Transfer(address indexed from, address indexed to, uint value);

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
        owner = msg.sender;
    }

    function initialize(uint256 _amount0, uint256 _amount1) external {
        require(token0.allowance(msg.sender, address(this)) >= _amount0 && 
        token1.allowance(msg.sender, address(this)) >= _amount1, "Insufficient allowance");
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        balances[1][msg.sender] = token0.balanceOf(msg.sender);
        balances[2][msg.sender] = token1.balanceOf(msg.sender);

        reserve0 += _amount0;
        reserve1 += _amount1;

        if(k == 0) {
           k = _amount0 * _amount1;
        }
    }

    function swap(uint256 _amount0Out, uint256 _amount1Out) external lock {
        require(owner == msg.sender, "Not owner");
        require(_amount0Out > 0 || _amount1Out > 0, "Insufficient input");
        require(k > 0, "no liquidity");
       

        if (_amount0Out > 0) {
            uint _amount1In = reserve1 - k/(reserve0 + _amount0Out);
             k = (reserve1 + _amount1In) * (reserve0 - _amount0Out);

            reserve1 += _amount1In;
            reserve0 -= _amount0Out;

            balances[2][msg.sender] -= _amount1In;
            balances[1][msg.sender] -= _amount0Out;

            token1.transferFrom(msg.sender, address(this), _amount1In);
            token0.transfer(msg.sender, _amount0Out);
            emit Transfer(address(this), msg.sender, _amount0Out);

        } else if (_amount1Out > 0) {
            uint _amount0In = reserve1 - k/(reserve0 + _amount1Out);
             k = (reserve0 + _amount0In) * (reserve1 - _amount1Out);

            reserve0 += _amount0In;
            reserve1 -= _amount1Out;

            balances[2][msg.sender] -= _amount0In;
            balances[1][msg.sender] -= _amount1Out;

            token0.transferFrom(msg.sender, address(this), _amount0In);
            token1.transfer(msg.sender, _amount1Out);
            emit Transfer(address(this), msg.sender, _amount1Out);
        }

        
    }

    
}

    
