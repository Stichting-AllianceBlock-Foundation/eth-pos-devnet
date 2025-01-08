# Ethereum Proof-of-Stake Devnet

You can follow the step by step guide at https://docs.prylabs.network/docs/advanced/proof-of-stake-devnet or for POA see linkedin post https://www.linkedin.com/pulse/guide-setting-up-fully-functional-prysm-beacon-node-validator-chan-rbwcc/ 
This repository provides a docker-compose file to run a fully-functional, local development network for Ethereum with proof-of-stake enabled. This configuration uses [Prysm](https://github.com/prysmaticlabs/prysm) as a consensus client and [go-ethereum](https://github.com/ethereum/go-ethereum) for execution. **It starts from proof-of-stake** and does not go through the Ethereum merge.

This sets up a single node development network with 64 deterministically-generated validator keys to drive the creation of blocks in an Ethereum proof-of-stake chain. Here's how it works:

1. We initialize a go-ethereum, proof-of-work development node from a genesis config. The beacon chain genesis block is set 15 seconds after the geth genesis to give it time to sync. 
2. We initialize a Prysm beacon chain, proof-of-stake development node from a genesis config

The development net is fully functional and allows for the deployment of smart contracts and all the features that also come with the Prysm consensus client such as its rich set of APIs for retrieving data from the blockchain. This development net is a great way to understand the internals of Ethereum proof-of-stake and to mess around with the different settings that make the system possible.

## Using

Then install Docker and run:

```
docker-compose up
```

You will see the following:

```
$ docker compose up -d
[+] Running 5/5
 ⠿ Container eth-pos-devnet-create-beacon-chain-genesis-1  Exited
 ⠿ Container eth-pos-devnet-beacon-chain-1                 Started
 ⠿ Container eth-pos-devnet-geth-genesis-1                 Exited
 ⠿ Container eth-pos-devnet-validator-1                    Started
 ⠿ Container eth-pos-devnet-geth-1                         Started
```

Each time you restart, you can wipe the old data using `./clean.sh`.

Next, you can inspect the logs of the different services launched. 

```
docker logs eth-pos-devnet-geth-1 -f
```

and see:

```
INFO [08-19|00:44:30.956] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=1.356ms     mgasps=0.000 number=50 hash=e0bd7f..497d27 dirty=0.00B
INFO [08-19|00:44:31.030] Chain head was updated                   number=50 hash=e0bd7f..497d27 root=815538..801014 elapsed=1.49025ms
INFO [08-19|00:44:35.215] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=3.243ms     mgasps=0.000 number=51 hash=a5fb7c..5e844b dirty=0.00B
INFO [08-19|00:44:35.311] Chain head was updated                   number=51 hash=a5fb7c..5e844b root=815538..801014 elapsed=1.73475ms
INFO [08-19|00:44:39.435] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=1.355ms     mgasps=0.000 number=52 hash=b2fd97..22e230 dirty=0.00B
INFO [08-19|00:44:39.544] Chain head was updated                   number=52 hash=b2fd97..22e230 root=815538..801014 elapsed=1.167959ms
INFO [08-19|00:44:42.733] Imported new potential chain segment     blocks=1 txs=0 mgas=0.000 elapsed=2.453ms     mgasps=0.000 number=53 hash=ee046e..e56b0c dirty=0.00B
INFO [08-19|00:44:42.747] Chain head was updated                   number=53 hash=ee046e..e56b0c root=815538..801014 elapsed="821.084µs"
```


We have also added a small  postman collection so you can test the services at [go-eth-stake.postman_collection.json](./go-eth-stake.postman_collection.json)


# Available Features

- Starts from the Capella Ethereum hard fork
- The network launches with a [Validator Deposit Contract](https://github.com/ethereum/consensus-specs/blob/dev/solidity_deposit_contract/deposit_contract.sol) deployed at address `0x4242424242424242424242424242424242424242`. This can be used to onboard new validators into the network by depositing 32 ETH into the contract
- The default account used in the go-ethereum node is address `0x123463a4b065722e99115d6c222f267d9cabb524` which comes seeded with ETH for use in the network. This can be used to send transactions, deploy contracts, and more
- The default account, `0x123463a4b065722e99115d6c222f267d9cabb524` is also set as the fee recipient for transaction fees proposed validators in Prysm. This address will be receiving the fees of all proposer activity
- The go-ethereum JSON-RPC API is available at http://geth:8545
- The Prysm client's REST APIs are available at http://beacon-chain:3500. For more info on what these APIs are, see [here](https://ethereum.github.io/beacon-APIs/) or a swagger at https://ethereum.github.io/beacon-APIs/#/Beacon/getStateValidators 
- The Prysm client also exposes a gRPC API at http://beacon-chain:4000 see [here](https://docs.prylabs.network/docs/how-prysm-works/prysm-public-api) But this is deprecated

<img width="1631" alt="5" src="https://user-images.githubusercontent.com/5572669/186052294-70909835-210f-4b13-86a3-cf1f568bb8a3.png">
<img width="1693" alt="3" src="https://user-images.githubusercontent.com/5572669/186052298-54b82ff2-a901-482e-9e5a-a7c265605ad6.png">
<img width="1426" alt="1" src="https://user-images.githubusercontent.com/5572669/186052301-dd487b50-183a-4fa6-bbec-216f32d6f03a.png">

# Configuration

## Secrets

You should change [jwtsecret](./execution/jwtsecret) see [here](https://docs.prylabs.network/docs/execution-node/authentication) for more information.
There is the posibility to add geth password, is currently not added in the docker compose, but it should be added for mainnet

## Genesis.json

The [genesis.json](./execution/genesis.json) corresponds to the values of the first block in the blockchain. The most important parameters to modify are:

### Chain Id
To change chainId you need to modify in [genesis.json](./execution/genesis.json) the following value

```json
"chainId": 32382, 
```

And then modify in [docker-compose.yml](./docker-compose.yml) the following configuration

```yml
beacon-chain:
    image: "gcr.io/prysmaticlabs/prysm/beacon-chain:v5.1.2"
    platform: "linux/amd64"
    command:
      # We specify the chain id used by our execution client
      - --chain-id=${CHAIN_ID:-32382}
```



This is the chainId that will be used, this value is an example, we should select a correct one that is not used by any other network for testnet. You can check the link in [chainlist](https://chainlist.org/) or [ethereum-lists/chains](https://github.com/ethereum-lists/chains)

### Nonce

```json
"nonce": 0x0, 
```

This nonce is a random number, the main purpose is to keep unwanted nodes (don't match the nonce) out of the network. This vale should be replaced witha  random value

### Accounts

The genesis.json sets the amount that will allocated to some addresses, this is given at `alloc`

```json
"alloc": {
    "123463a4b065722e99115d6c222f267d9cabb524": {
        "balance": "0x43c33c1937564800000"
    },
```

Balance is the hex amount in WEI
*Address 0x123463a4b065722e99115d6c222f267d9cabb524 private key is public, so YOU SHOULD CHANGE THIS ACCOUNTS*


There are also smart contracts that are added at this point, the most important one is the deposit contract address 4242424242424242424242424242424242424242, that is used by Prysm

```json
"4242424242424242424242424242424242424242": {
			"code": "0x6080604052600...
```

*This should also be set at [consensus/config.yml](./consensus/config.yml)

```yml
# Deposit contract
DEPOSIT_CONTRACT_ADDRESS: 0x4242424242424242424242424242424242424242
```

### Validator

The first validator is obtained from [genesis.json](./execution/genesis.json) extraData, in this example it's the address 0x123463a4b065722e99115d6c222f267d9cabb524.

```json
"extraData": "0x0000000000000000000000000000000000000000000000000000000000000000123463a4b065722e99115d6c222f267d9cabb5240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
```

Take into account that this account has to be accesible by the geth node, that's why in the [docker-compose.yml](./docker-compose.yml) we unlock it:

```yml
geth:
    image: "ethereum/client-go:v1.14.12"
    command:
      - --unlock=0x123463a4b065722e99115d6c222f267d9cabb524
```


## Fee Recipient

Fee Recipient is a feature that lets you specify a priority fee recipient address on your validator client instance and beacon node.
Currently is configured for 0x123463a4b065722e99115d6c222f267d9cabb524 at docker-compose.yml

```yml
beacon-chain:
    image: "gcr.io/prysmaticlabs/prysm/beacon-chain:v5.1.2"
    platform: "linux/amd64"
    command:
      - --suggested-fee-recipient=0x123463a4b065722e99115d6c222f267d9cabb524
```

*This should be changed as private key of 0x123463a4b065722e99115d6c222f267d9cabb524 is of public knowledge*

## Time between blocks

To configure the time in senconds betweens blocks you need to modify the SECONDS_PER_SLOT at [config.yml](./consensus/config.yml) of the becon chain

```yml
# Time parameters
SECONDS_PER_SLOT: 12
SLOTS_PER_EPOCH: 6
```

Here the default is set as 12 seconds between blocks. 

## New forks

If you see an error like `error="could not set config params: version 0x06000000 for fork fulu in config interop conflicts with existing config`.
It means that there is a hard fork detected at the Beacon chain but it's not configured at the [config.yml](./consensus/config.yml).
We should add the new fork adding plus one to the previous fork value like this

```yml
# Fulu
FUKU_FORK_VERSION: 0x20000095
```

This adds the fork but it does not activate it, in order to activate it you should add a fork EPOC like this

```yml
# Deneb
DENEB_FORK_EPOCH: 0
DENEB_FORK_VERSION: 0x20000093
```

# Mac M1 (ARM)
On docker compose we have added `platform: "linux/amd64"` in order to run it on Mac M1, this configuration is not needed on other platforms

# Archive nodes

When running an archive node besides the `--gcmode=archive` flag you'll need to ad the `--state.scheme=hash` flag at geth init, otherwise you'll get a [Failed to register the Ethereum service: incompatible state scheme](https://github.com/ethereum-optimism/op-geth/issues/375) error

# Mainnet
Changes needed to be made for mainnet:
- Change [Chain ID](#chain-id)
- Configure [Fee Recipient Address](#fee-recipient)
- Configure mint balance [Accounts](#accounts)
- The geth flags `--http.api=txpool,debug`, `--ws.api=txpool,debug`, `--gcmode=archive` and `--state.scheme=hash` should be removed from the geth node connected to the validator and we should have a dedicated geth node with this flags for the explorer.
- Put the nodes inside a firewall and private network to avoid them being called from the outside using http calls and such.
- Set geth cors, origins, and other related data that involves security.
- Set defined peers to connect to other validators.
- Set a public node that is connected to the private network, so people outside the network can discover it and connect, but they can't reach the private network with the valdiators.
- Follow [security best practices](https://docs.prylabs.network/docs/security-best-practices)

# FAQ / Common Issues

- ```Nil finalized block cannot evict old blobs```

This is expected log from Geth until a block is 'finalized'. The first finalized block will occur after 24 blocks.
