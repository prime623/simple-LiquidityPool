import { ethers } from "hardhat";
import { Signer } from "ethers";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";

describe("Token", function () {
  let accounts: Signer[];
  let owner: SignerWithAddress;

  beforeEach(async function () {
    [owner, ...accounts] = await ethers.getSigners();
  });

  it("should deploy all of the contracts, then test the functions inside the pool contracts and increase the starting balance through arbitrage", async function () {
  
    // contract deployment and saving the addresses
    const Prime1 = await ethers.getContractFactory("Prime1");
    const prime1 = await Prime1.deploy();
    await prime1.deployed();
    const token1 = prime1.address;
    //console.log(token1);

    const Prime2 = await ethers.getContractFactory("Prime2");
    const prime2 = await Prime2.deploy();
    await prime2.deployed();
    const token2 = prime2.address;
    //console.log(token2);

    const Pool1 = await ethers.getContractFactory("Pool");
    const pool1 = await Pool1.deploy(token1, token2);
    await pool1.deployed();
    const pool1Addr = pool1.address;

    const Pool2 = await ethers.getContractFactory("Pool2");
    const pool2 = await Pool2.deploy(token1, token2);
    await pool2.deployed();
    const pool2Addr = pool2.address;

    // Approving the pool contracts to spend owner's tokens
    const allowance1 = prime1.approve(pool1Addr, ethers.utils.parseEther("1000"));
    const allowance2 = prime2.approve(pool1Addr, ethers.utils.parseEther("2000"));

    const allowance3 = prime1.approve(pool2Addr, ethers.utils.parseEther("2000"));
    const allowance4 = prime2.approve(pool2Addr, ethers.utils.parseEther("1000"));

    const check = await prime1.allowance(owner.address, pool1Addr); // Test to see if the approve function worked.
    console.log(check.toString());

    // Initializion and swapping
    pool1.initialize(ethers.utils.parseEther("100"), ethers.utils.parseEther("200"));
    console.log("Balance of token0 on initialization of pool1: ", await prime1.balanceOf(owner.address));
    console.log("Balance of token1 on initialization of pool1: ", await prime2.balanceOf(owner.address));
    pool2.initialize(ethers.utils.parseEther("200"), ethers.utils.parseEther("100"));
    console.log("Balance of token0 on initialization of pool2: ", await prime1.balanceOf(owner.address));
    console.log("Balance of token1 on initialization of pool2: ", await prime2.balanceOf(owner.address));

    const swap1 = pool1.swapAforB(ethers.utils.parseEther("10"));
    console.log(await prime1.balanceOf(owner.address));
    console.log(await prime2.balanceOf(owner.address));

    
    const swap2 = pool2.swapBforA(ethers.utils.parseEther("20"));
    console.log(await prime1.balanceOf(owner.address));
    console.log(await prime2.balanceOf(owner.address));
    
    
});
});
