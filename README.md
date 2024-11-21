# Sui Move Course

This repository is a collection of my notes and exercises from the [Sui Move Course](https://github.com/sui-foundation/sui-move-intro-course/tree/main).

## Deploy Contract

`sui client publish --gas-budget <gas_budget> [absolute file path to the package that needs to be published]`

## Call a Method through a Transaction

`sui client call --function <function_name> --module <module_name> --package <package_id> --gas-budget 10000000`
