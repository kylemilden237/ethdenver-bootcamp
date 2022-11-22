const { ethers } = require("hardhat");
const provider = ethers.getDefaultProvider("http://localhost:8545");

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function test() {
  const impersonatedSigner = await ethers.getImpersonatedSigner("0x71bE63f3384f5fb98995898A86B02Fb2426c5788");
  let answer = await impersonatedSigner.sendTransaction({to: "0xD2570eef08b5Ff825D761a24187f966BE27deC5D", value: ethers.utils.parseEther("10")});
  await sleep(20000);

  provider.getBalance("0x71bE63f3384f5fb98995898A86B02Fb2426c5788").then((balance) => {
    const balanceInEth = ethers.utils.formatEther(balance)
    console.log(`balance 0x71bE63f3384f5fb98995898A86B02Fb2426c5788: ${balanceInEth} ETH`)
  });
  
   provider.getBalance("0xD2570eef08b5Ff825D761a24187f966BE27deC5D").then((balance) => {
    const balanceInEth = ethers.utils.formatEther(balance)
    console.log(`balance 0xD2570eef08b5Ff825D761a24187f966BE27deC5D: ${balanceInEth} ETH`)
  });
};

test();
