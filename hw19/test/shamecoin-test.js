const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ShameCoin1", function () {
  let shameCoinContract;
  let owner, admin, addr2, addr3;

  beforeEach(async function () {
    [owner, admin, addr2, addr3] = await ethers.getSigners();

    const ShameCoin1 = await ethers.getContractFactory("ShameCoin");
    shameCoinContract = await ShameCoin1.deploy(10000, admin.address);
    await shameCoinContract.deployed();
  });

  it("Check Deployment", async function () {
    expect(await shameCoinContract.totalSupply()).to.equal(10000);
    expect(await shameCoinContract.balanceOf(admin.address)).to.equal(10000);
    expect(await shameCoinContract.administrator()).to.equal(admin.address);
  });

  it("Check Transfer of 1", async function () {
    await shameCoinContract.connect(admin).transfer(addr2.address, 123);
    expect(await shameCoinContract.balanceOf(addr2.address)).to.equal(1);
    expect(await shameCoinContract.balanceOf(admin.address)).to.equal(9999);
  });

  it("Check Non admin transfer", async function () {
    await shameCoinContract.connect(addr2).transfer(addr3.address, 123);
    expect(await shameCoinContract.balanceOf(addr2.address)).to.equal(1);
    expect(await shameCoinContract.balanceOf(addr3.address)).to.equal(0);
  });

  it("Non admin approve transfer", async function () {
    await shameCoinContract.connect(admin).transfer(addr2.address, 123);
    expect(await shameCoinContract.balanceOf(addr2.address)).to.equal(1);

    await shameCoinContract.connect(addr2).approve(admin.address, 123);
    await shameCoinContract.connect(admin).transferFrom(addr2.address, addr3.address, 1);
    expect(await shameCoinContract.balanceOf(addr2.address)).to.equal(0);
    expect(await shameCoinContract.balanceOf(addr3.address)).to.equal(0);
  });

});
