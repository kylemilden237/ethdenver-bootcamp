module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const {account0} = await getNamedAccounts();

  await deploy("VolcanoCoin", {
    from: account0,
    args: [10000, "VolcanoCoin", 0, "VC"],
    log: true,
  });

  await deploy("VolcanoNFT", {
    from: account0,
    args: [],
    log: true,
  });
};