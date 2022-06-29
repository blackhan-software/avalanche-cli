#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh index get-last-accepted" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'https://api.avax.network/ext/index/${2-X/tx}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"index.getLastAccepted",' ;
    expect_d+='"params":{' ;
    expect_d+='"encoding":"hex"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_index_get_last_accepted_0 {
    check "$(AVAX_ID_RPC=1 $(cmd))" ;
}

function test_index_get_last_accepted_1 {
    check "$(AVAX_ID_RPC=1 $(cmd) -e hex -b X -n tx)" ;
}

function test_index_get_last_accepted_2 {
    check "$(AVAX_ID_RPC=1 AVAX_ENCODING=hex $(cmd) -b X -n tx)" ;
}

function test_index_get_last_accepted_3a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=X $(cmd) -e hex -n tx)" ;
}

function test_index_get_last_accepted_3b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=tx $(cmd) -e hex -b X)" ;
}

function test_index_get_last_accepted_3c {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=vtx $(cmd) -e hex -b X)" "X/vtx" ;
}

function test_index_get_last_accepted_4a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=P $(cmd) -e hex -n block)" "P/block" ;
}

function test_index_get_last_accepted_4b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=block $(cmd) -e hex -b P)" "P/block" ;
}

function test_index_get_last_accepted_5a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=C $(cmd) -e hex -n block)" "C/block" ;
}

function test_index_get_last_accepted_5b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=block $(cmd) -e hex -b C)" "C/block" ;
}

###############################################################################
###############################################################################
