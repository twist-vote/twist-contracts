import { JsonRpcProvider } from "@ethersproject/providers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "ethers";

const arbProvider = new JsonRpcProvider("");

export default (deployer: SignerWithAddress) => {
  const l1Signer = deployer;
};
