#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh admin get-blockchain-id" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/admin'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"admin.getBlockchainID",' ;
    expect_d+='"params":{' ;
    expect_d+='"alias":"ALIAS"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_admin__blockchain_id_1a {
    check "$(RPC_ID=1 $(cmd) -a ALIAS)" ;
}

function test_admin__blockchain_id_1b {
    check "$(RPC_ID=1 AVA_ALIAS=ALIAS $(cmd))" ;
}

###############################################################################
###############################################################################
