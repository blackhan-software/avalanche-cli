#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avm create-mint-tx" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/bc/${2-X}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"avm.createMintTx",' ;
    expect_d+='"params":{' ;
    expect_d+='"amount":1000000000000000,' ;
    expect_d+='"assetID":"ASSET_ID",' ;
    expect_d+='"to":"TO",' ;
    expect_d+='"minters":["M1","M2","M3"]' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__create_mint_tx_1a {
    check "$(AVA_ID_RPC=1 $(cmd) \
        -# 1P -a ASSET_ID -@ TO -m M1 -m M2 -m M3)" ;
}

function test_avm__create_mint_tx_1b {
    check "$(AVA_ID_RPC=1 AVA_AMOUNT=1P $(cmd) \
        -a ASSET_ID -@ TO -m M1 -m M2 -m M3)" ;
}

function test_avm__create_mint_tx_1c {
    check "$(AVA_ID_RPC=1 AVA_ASSET_ID=ASSET_ID $(cmd) \
        -# 1P -@ TO -m M1 -m M2 -m M3)" ;
}

function test_avm__create_mint_tx_1d {
    check "$(AVA_ID_RPC=1 AVA_TO=TO $(cmd) \
        -# 1P -a ASSET_ID -m M1 -m M2 -m M3)" ;
}

function test_avm__create_mint_tx_2a {
    check "$(AVA_ID_RPC=1 \
        AVA_MINTER_0=M1 $(cmd) \
        -# 1P -a ASSET_ID -@ TO -m M2 -m M3)" ;
}

function test_avm__create_mint_tx_2b {
    check "$(AVA_ID_RPC=1 \
        AVA_MINTER_0=M1 AVA_MINTER_1=M2 $(cmd) \
        -# 1P -a ASSET_ID -@ TO -m M3)" ;
}

function test_avm__create_mint_tx_2c {
    check "$(AVA_ID_RPC=1 \
        AVA_MINTER_0=M1 AVA_MINTER_1=M2 AVA_MINTER_2=M3 $(cmd) \
        -# 1P -a ASSET_ID -@ TO)" ;
}

function test_avm__create_mint_tx_3a {
    check "$(AVA_ID_RPC=1 $(cmd) \
        -# 1P -a ASSET_ID -@ TO \
        -m M1 -m M2 -m M3 -b BC_ID)" BC_ID ;
}

function test_avm__create_mint_tx_3b {
    check "$(AVA_ID_RPC=1 AVA_BLOCKCHAIN_ID=BC_ID $(cmd) \
        -# 1P -a ASSET_ID -@ TO -m M1 -m M2 -m M3)" BC_ID ;
}

###############################################################################
###############################################################################
