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
    expect_d+='"payerNonce":3' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__create_blockchain_1a {
    check "$(RPC_ID=1 $(cmd) \
        -s SUBNET_ID -v VM_ID -n NAME -% 3 -g GENESIS_DATA)" ;
}

function test_platform__create_blockchain_1b {
    check "$(RPC_ID=1 AVA_SUBNET_ID=SUBNET_ID $(cmd) \
        -v VM_ID -n NAME -% 3 -g GENESIS_DATA)" ;
}

function test_platform__create_blockchain_1c {
    check "$(RPC_ID=1 AVA_VM_ID=VM_ID $(cmd) \
        -s SUBNET_ID -n NAME -% 3 -g GENESIS_DATA)" ;
}

function test_platform__create_blockchain_1d {
    check "$(RPC_ID=1 AVA_NAME=NAME $(cmd) \
        -s SUBNET_ID -v VM_ID -% 3 -g GENESIS_DATA)" ;
}

function test_platform__create_blockchain_1e {
    check "$(RPC_ID=1 AVA_PAYER_NONCE=3 $(cmd) \
        -s SUBNET_ID -v VM_ID -n NAME -g GENESIS_DATA)" ;
}

function test_platform__create_blockchain_1f {
    check "$(RPC_ID=1 AVA_GENESIS_DATA=GENESIS_DATA $(cmd) \
        -s SUBNET_ID -v VM_ID -n NAME -% 3)" ;
}

###############################################################################
###############################################################################
