import { HardhatUserConfig } from "hardhat/types";
import { task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-deploy";
import "@typechain/hardhat";
import "solidity-coverage";
// import "hardhat-contract-sizer";
// import "hardhat-gas-reporter";
import dotenv from "dotenv";

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

export default {
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  loggingEnabled: true,
  mocha: {
    timeout: 1000000,
  },
  typechain: {
    outDir: "compiled-types/",
    externalArtifacts: ["external-artifacts/**/*.sol/!(*.dbg.json)"],
    target: "ethers-v5",
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 21,
  },
  namedAccounts: {
    deployer: {
      default: 0,
      kovan: 0,
      mainnet: 0,
      rinkeby: 0,
    },
    bribeMultisig: process.env.BRIBE_MULTISIG || 1,
  },
  networks: {
    hardhat: {
      // loggingEnabled: true,
      // forking: {
      //   url: "https://eth-rinkeby.alchemyapi.io/v2/rS5snw1GvYxLnKfpbWX34XGnTr8NkI6U",
      // },
      saveDeployments: true,
    },
    bribe: {
      url: "https://hh-node.thibautduchene.fr",
    },
    localhost: {
      // loggingEnabled: true,
      url: "http://localhost:8545",
    },
    rinkeby: {
      chainId: 4,
      accounts: {
        mnemonic: process.env.MNEMONIC || "",
      },
      url: "https://eth-rinkeby.alchemyapi.io/v2/rS5snw1GvYxLnKfpbWX34XGnTr8NkI6U",
      companionNetworks: {
        arbitrum: "arbitrum",
      },
    },
    arbitrum: {
      chainId: 421611,
      accounts: {
        mnemonic: process.env.MNEMONIC || "",
      },
      url: "https://arb-rinkeby.g.alchemy.com/v2/yUnKFcXSi6HXxCzN4Qmjll_oVRFkWLtz",
      companionNetworks: {
        rinkeby: "rinkeby",
      },
      deploy: "deploy-arbitrum",
    },
    polygon: {
      url: "https://polygon-rpc.com",
    },
    kovan: {
      accounts: {
        mnemonic: process.env.MNEMONIC || "",
      },
      // url: process.env.KOVAN_ALCHEMY_API
      url: "https://eth-kovan.alchemyapi.io/v2/M6qPjym_xS1lMm06pXcuKKJAYBUaxFmV",
    },
    mainnet: {
      accounts: {
        mnemonic: process.env.MNEMONIC || "",
      },
      url: "https://eth-mainnet.alchemyapi.io/v2/_LS3GHbsERYSBAaJw5HECdKjRIIp8dPS",
    },
  },
  external: {
    contracts: [
      {
        artifacts: "external-artifacts",
      },
    ],
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: process.env.API_KEY || "",
  },
} as HardhatUserConfig;
