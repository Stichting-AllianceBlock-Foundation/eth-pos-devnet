#!/bin/bash
rm -Rf ./consensus/beacondata ./consensus/validatordata ./consensus/genesis.ssz
bash geth-remove-db.sh
