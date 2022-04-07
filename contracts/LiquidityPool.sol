//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Prime1 is ERC20 {

    constructor () ERC20("Prime1", "P1") {
        _mint(msg.sender, 10000 ether);
    }

}

contract Prime2 is ERC20 {
    constructor () ERC20("Prime2", "P2") {
        _mint(msg.sender, 5000 ether);
    }
}

contract Pool {
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

    function initialize(uint256 _amount0, uint256 _amount1) external lock {
        require(token0.allowance(msg.sender, address(this)) >= _amount0 && 
        token1.allowance(msg.sender, address(this)) >= _amount1, "Insufficient allowance");

        reserve0 += _amount0;
        reserve1 += _amount1;

        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        balances[1][msg.sender] = token0.balanceOf(msg.sender);
        balances[2][msg.sender] = token1.balanceOf(msg.sender);

        

        if(k == 0) {
           k = _amount0 * _amount1;
        }
    }

    function swapAforB(uint256 _amount0In) external lock {
        require(owner == msg.sender, "Not owner");
        require(_amount0In > 0, "Insufficient input");
        require(k > 0, "no liquidity");

        //uint bal0 = reserve0;
        //uint bal1 = reserve1;
        
        uint _amount1Out = reserve1 - k/(reserve0 + _amount0In);
        k = (reserve0 + _amount0In) * (reserve1 - _amount1Out);
        reserve0 += _amount0In;
        reserve1 -= _amount1Out;
        balances[1][msg.sender] -= _amount0In;
        balances[2][msg.sender] += _amount1Out;

       
        token0.transferFrom(msg.sender, address(this), _amount0In);
        token1.transfer(msg.sender, _amount1Out);
        emit Transfer(address(this), msg.sender, _amount1Out);

        
    }

        function swapBforA(uint256 _amount1In) external lock {
            require(owner == msg.sender, "Not owner");
            require(_amount1In > 0, "Insufficient input amount");
            require(k > 0, "no liquidity");

            uint _amount0Out = reserve0 - k/(reserve1 + _amount1In);
            k = (reserve1 + _amount1In) * (reserve0 - _amount0Out);
            reserve1 += _amount1In;
            reserve0 -= _amount0Out;
            balances[1][msg.sender] += _amount0Out;
            balances[2][msg.sender] -= _amount1In;
           

            token1.transferFrom(msg.sender, address(this), _amount1In);
            token0.transfer(msg.sender, _amount0Out);
            emit Transfer(address(this), msg.sender, _amount0Out);
            }
    
}

contract Pool2 {
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

    function initialize(uint256 _amount0, uint256 _amount1) external lock {
        require(token0.allowance(msg.sender, address(this)) >= _amount0 && 
        token1.allowance(msg.sender, address(this)) >= _amount1, "Insufficient allowance");

        reserve0 += _amount0;
        reserve1 += _amount1;

        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        balances[1][msg.sender] = token0.balanceOf(msg.sender);
        balances[2][msg.sender] = token1.balanceOf(msg.sender);

        if(k == 0) {
           k = _amount0 * _amount1;
        }
    }

    function swapAforB(uint256 _amount0In) external lock {
        require(owner == msg.sender, "Not owner");
        require(_amount0In > 0, "Insufficient input");
        require(k > 0, "no liquidity");

        uint _amount1Out = reserve1 - k/(reserve0 + _amount0In);
        k = (reserve0 + _amount0In) * (reserve1 - _amount1Out);
        reserve0 += _amount0In;
        reserve1 -= _amount1Out;
        balances[1][msg.sender] -= _amount0In;
        balances[2][msg.sender] += _amount1Out;

       
        token0.transferFrom(msg.sender, address(this), _amount0In);
        token1.transfer(msg.sender, _amount1Out);
        emit Transfer(address(this), msg.sender, _amount1Out);


    }

        function swapBforA(uint256 _amount1In) external lock {
            require(owner == msg.sender, "Not owner");
            require(_amount1In > 0, "Insufficient input amount");
            require(k > 0, "no liquidity");

            //uint bal0 = reserve0;
            //uint bal1 = reserve1;
            
            uint _amount0Out = reserve0 - k/(reserve1 + _amount1In);
            k = (reserve1 + _amount1In) * (reserve0 - _amount0Out);
            reserve1 += _amount1In;
            reserve0 -= _amount0Out;
            balances[1][msg.sender] += _amount0Out;
            balances[2][msg.sender] -= _amount1In;
    
           

            token1.transferFrom(msg.sender, address(this), _amount1In);
            token0.transfer(msg.sender, _amount0Out);
            emit Transfer(address(this), msg.sender, _amount0Out);
            }

            

    
}

    
