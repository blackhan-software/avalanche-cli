#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform get-utxos" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'https://api.avax.network/ext/P'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"platform.getUTXOs",' ;
    expect_d+='"params":{' ;
    expect_d+='"addresses":["P1","P2","P3"],' ;
    expect_d+='"limit":1024,' ;
    expect_d+='"startIndex":{' ;
    expect_d+='"address":"SI_P0",' ;
    expect_d+='"utxo":"SI_UTXO"' ;
    expect_d+="}," ;
    expect_d+='"sourceChain":"X"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__get_utxos_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) -@P1 -@P2 -@P3 -l 1024 \
        --start-index-address=SI_P0 --start-index-utxo=SI_UTXO -s X)" ;
}

function test_platform__get_utxos_1b {
    check "$(AVAX_ID_RPC=1 \
        AVAX_ADDRESS_0=P1 AVAX_ADDRESS_1=P2 AVAX_ADDRESS_2=P3 $(cmd) -l 1024 \
        --start-index-address=SI_P0 --start-index-utxo=SI_UTXO -s X)" ;
}

function test_platform__get_utxos_1c {
    check "$(AVAX_ID_RPC=1 AVAX_START_INDEX_ADDRESS=SI_P0 \
        $(cmd) -@P1 -@P2 -@P3 -l 1024 --start-index-utxo=SI_UTXO -s X)" ;
}

function test_platform__get_utxos_1d {
    check "$(AVAX_ID_RPC=1 AVAX_START_INDEX_UTXO=SI_UTXO \
        $(cmd) -@P1 -@P2 -@P3 -l 1024 --start-index-address=SI_P0 -s X)" ;
}

function test_platform__get_utxos_1e {
    check "$(AVAX_ID_RPC=1 AVAX_SOURCE_CHAIN=X $(cmd) -@P1 -@P2 -@P3 -l 1024 \
        --start-index-address=SI_P0 --start-index-utxo=SI_UTXO)" ;
}

###############################################################################
###############################################################################
