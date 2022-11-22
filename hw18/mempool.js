var ethers = require("ethers");
var url = "wss://eth-mainnet.g.alchemy.com/v2/JTuVq5zntYPcIPoCk56GnAw82kRD69kT";
var init = function () {
  var customWsProvider = new ethers.providers.WebSocketProvider(url);

  customWsProvider.on("pending", (tx) => {
    customWsProvider.getTransaction(tx).then(function (transaction) {
      console.log(transaction);
    });
  });
};
init();
