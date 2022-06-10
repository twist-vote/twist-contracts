import { BigNumber } from "ethers/lib/ethers";
import { parseBytes32String, solidityKeccak256, toUtf8String } from "ethers/lib/utils";
import { ethers } from "ethers";
import bs58 from "bs58";
import { MerkleTree } from "./utils";

export function stringFromBytes32(bytes32Hex: string) {
  const hashHex = bytes32Hex.slice(2);
  const hashBytes = Buffer.from(hashHex, "hex");
  const hashStr = bs58.encode(hashBytes);
  return hashStr;
}

export const tree = merkletree([{ account: ethers.constants.AddressZero, vp: BigNumber.from(1) }]);

export const root0 = tree.getHexRoot();

export const proof0 = tree.getHexProof(
  Buffer.from(
    solidityKeccak256(
      ["address", "uint256"],
      [ethers.constants.AddressZero, BigNumber.from(1)]
    ).substring(2),
    "hex"
  )
);

export function merkletree(holders: { account: string; vp: BigNumber }[]): MerkleTree {
  const leaves = holders.map((th) => {
    return Buffer.from(
      solidityKeccak256(["address", "uint256"], [th.account, th.vp]).substring(2),
      "hex"
    );
  });
  const tree = new MerkleTree(leaves);
  // tree.getRoot();
  return tree;
}

console.log(root0);
