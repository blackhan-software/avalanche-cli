#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform issue-tx" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'https://api.avax.network/ext/bc/${2-P}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"platform.issueTx",' ;
    expect_d+='"params":{' ;
    expect_d+='"tx":"TX",' ;
    expect_d+='"encoding":"hex"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__issue_tx_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) -t TX -e hex)" ;
}

function test_platform__issue_tx_1b {
    check "$(AVAX_ID_RPC=1 AVAX_TX=TX $(cmd))" ;
}

function test_platform__issue_tx_1c {
    check "$(AVAX_ID_RPC=1 AVAX_ENCODING=hex $(cmd) -t TX)" ;
}

function test_platform__issue_tx_2a {
    check "$(AVAX_ID_RPC=1 $(cmd) -t TX -b BC_ID)" BC_ID ;
}

function test_platform__issue_tx_2b {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=BC_ID $(cmd) -t TX)" BC_ID ;
}

###############################################################################
###############################################################################
