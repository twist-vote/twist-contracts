forge create \
  --rpc-url "https://polygon-mainnet.g.alchemy.com/v2/zxPkW4ZZS-2qZqjIV2FCqaj4fhUmLW0M" \
  --constructor-args "0x6E831379FAE5AF708f6dd6Bc38c7d6eef83FdDA1" "0xdbe8b9a1afbeb68606d846cf2188d9f3ba3a8993" "0x2c472e8c04d4819839edbb18c477b0202b727440" \
  --chain "polygon" \
  --private-key $KEY \
  --legacy \
  --json \
  src/spacePot/SpacePotFactory.sol:SpacePotFactory \
  > constructors/pots/space-pot-factory.json