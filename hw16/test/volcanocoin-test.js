const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VolcanoCoin1", function () {
  let volcanoCoinContract;
  let owner, addr1, addr2, addr3;

  beforeEach(async function () {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();

    const VolcanoCoin1 = await ethers.getContractFactory("VolcanoCoin");
    volcanoCoinContract = await VolcanoCoin1.deploy(10000, "VolcanoCoin", 0, "VC");
    await volcanoCoinContract.deployed();
  });

});
