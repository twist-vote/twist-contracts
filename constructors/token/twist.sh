forge create \
  --rpc-url "https://polygon-mainnet.g.alchemy.com/v2/zxPkW4ZZS-2qZqjIV2FCqaj4fhUmLW0M" \
  --chain "polygon" \
  --constructor-args 100000000000000000000000000 "0x9B63404C4CfCE7bA805a076efd7955cb6dDA49c3" \
  --private-key $KEY \
  --legacy \
  --json \
  src/token/Twist.sol:Twist \
  > constructors/token/twist.json