module.exports = {
  networks: {
    dev: {
      protocol: 'http',
      host: 'localhost',
      port: 8545,
      gas: 6700000,
      gasPrice: 5e9,
      networkId: '*',
    },
  },
};
