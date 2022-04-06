import { ethers } from "hardhat";
import { Signer } from "ethers";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";

describe("Liquidity pool", function () {
  let accounts: Signer[];
  let owner: SignerWithAddress;

  beforeEach(async function () {
    [owner, ...accounts] = await ethers.getSigners();
  });

  it("should deploy all of the contracts, then test the functions inside the pool contracts and increase the starting balance through arbitrage", async function () {
  
    // contract deployment and saving the addresses
    const Prime3 = await ethers.getContractFactory("Prime3");
    const prime3 = await Prime3.deploy();
    await prime3.deployed();
    const token3 = prime3.address;
    

    const Prime4 = await ethers.getContractFactory("Prime4");
    const prime4 = await Prime4.deploy();
    await prime4.deployed();
    const token4 = prime4.address;
    

    const Pool3 = await ethers.getContractFactory("Pool3");
    const pool3 = await Pool3.deploy(token3, token4);
    await pool3.deployed();
    const pool3Addr = pool3.address;

    const Pool4 = await ethers.getContractFactory("Pool4");
    const pool4 = await Pool4.deploy(token3, token4);
    await pool4.deployed();
    const pool4Addr = pool4.address;

    // Approving the pool contracts to spend owner's tokens
    const allowance1 = prime3.approve(pool3Addr, ethers.utils.parseEther("1000"));
    const allowance2 = prime4.approve(pool3Addr, ethers.utils.parseEther("2000"));

    const allowance3 = prime3.approve(pool4Addr, ethers.utils.parseEther("2000"));
    const allowance4 = prime4.approve(pool4Addr, ethers.utils.parseEther("1000"));

    const check = await prime3.allowance(owner.address, pool3Addr); // Test to see if the approve function worked.
    console.log(check.toString());

    // Initializion and swapping
    pool3.initialize(ethers.utils.parseEther("100"), ethers.utils.parseEther("200"));
    console.log("Balance of token0 on initialization of pool3: ", await prime3.balanceOf(owner.address));
    console.log("Balance of token1 on initialization of pool3: ", await prime4.balanceOf(owner.address));
    pool4.initialize(ethers.utils.parseEther("200"), ethers.utils.parseEther("100"));
    console.log("Balance of token0 on initialization of pool4: ", await prime3.balanceOf(owner.address));
    console.log("Balance of token1 on initialization of pool4: ", await prime4.balanceOf(owner.address));

    const swap1 = pool3.swap(0, ethers.utils.parseEther("10"));
    const bal0 = await prime3.balanceOf(owner.address);
    const bal1 = await prime4.balanceOf(owner.address);
    console.log(bal0.toString());
    console.log(bal1.toString());
    
    const swap2 = pool4.swap(ethers.utils.parseEther("20"), 0);
    const bal3 = await prime3.balanceOf(owner.address);
    const bal4 = await prime4.balanceOf(owner.address);
    console.log(bal3.toString());
    console.log(bal4.toString());
    
    
});
});
