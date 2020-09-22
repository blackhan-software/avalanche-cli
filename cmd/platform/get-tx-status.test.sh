#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform get-tx-status" ;
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
    expect_d+='"method":"platform.getTxStatus",' ;
    expect_d+='"params":{' ;
    expect_d+='"txID":"TX_ID"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__get_tx_status_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) -t TX_ID)" ;
}

function test_avm__get_tx_status_1b {
    check "$(AVAX_ID_RPC=1 AVAX_TX_ID=TX_ID $(cmd))" ;
}

###############################################################################
###############################################################################
