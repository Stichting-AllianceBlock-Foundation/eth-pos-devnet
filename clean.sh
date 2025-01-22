#!/bin/bash
rm -Rf ./consensus/beacondata ./consensus/validatordata ./consensus/genesis.ssz
rm -Rf ./execution/geth
rm -Rf ./execution/geth.ipc
rm -Rf ./execution/retrh ./execution/blobstore/ ./execution/invalid_block_hooks/ ./execution/db ./execution/static_files/
rm -rf 	./execution/discovery-secret \
	./execution/known-peers.json \
	./execution/reth.toml
