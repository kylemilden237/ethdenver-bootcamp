module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const {account0} = await getNamedAccounts();

  await deploy("ShameCoin", {
    from: account0,
    args: [10000, "0x467676D8189c6ff96D337AfA76136557dE6F2F0d"],
    log: true,
  });

};