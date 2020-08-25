#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform create-blockchain" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/P'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"platform.createBlockchain",' ;
    expect_d+='"params":{' ;
    expect_d+='"subnetID":"SUBNET_ID",' ;
    expect_d+='"vmID":"VM_ID",' ;
    expect_d+='"name":"NAME",' ;
    expect_d+='"genesisData":"GENESIS_DATA",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__create_blockchain_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -s SUBNET_ID -v VM_ID -n NAME -g GENESIS_DATA \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_blockchain_1b {
    check "$(AVAX_ID_RPC=1 AVAX_SUBNET_ID=SUBNET_ID $(cmd) \
        -v VM_ID -n NAME -g GENESIS_DATA \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_blockchain_1c {
    check "$(AVAX_ID_RPC=1 AVAX_VM_ID=VM_ID $(cmd) \
        -s SUBNET_ID -n NAME -g GENESIS_DATA \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_blockchain_1d {
    check "$(AVAX_ID_RPC=1 AVAX_NAME=NAME $(cmd) \
        -s SUBNET_ID -v VM_ID -g GENESIS_DATA \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_blockchain_1e {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -s SUBNET_ID -v VM_ID -n NAME -g GENESIS_DATA \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_blockchain_1f {
    check "$(AVAX_ID_RPC=1 AVAX_GENESIS_DATA=GENESIS_DATA $(cmd) \
        -s SUBNET_ID -v VM_ID -n NAME \
        -u USERNAME -p PASSWORD)" ;
}

###############################################################################
###############################################################################
