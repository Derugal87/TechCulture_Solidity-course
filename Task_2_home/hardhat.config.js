require('dotenv').config();
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    testnet: {
      url: "https://bsctestapi.terminet.io/rpc",
      chainId: 97,
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
    },
  },
};
