forge create \
  --rpc-url "https://polygon-mainnet.g.alchemy.com/v2/zxPkW4ZZS-2qZqjIV2FCqaj4fhUmLW0M" \
  --chain "polygon" \
  --private-key $KEY \
  --legacy \
  --json \
  src/spacePot/SpacePot.sol:SpacePot \
  > constructors/pots/space-pot.json