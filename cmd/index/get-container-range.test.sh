#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh index get-container-range" ;
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
    expect_d+='"method":"index.getContainerRange",' ;
    expect_d+='"params":{' ;
    expect_d+='"startIndex":0,' ;
    expect_d+='"numToFetch":100,' ;
    expect_d+='"encoding":"cb58"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_index_get_container_range_0 {
    check "$(AVAX_ID_RPC=1 $(cmd) -i 0 -f 100)" ;
}

function test_index_get_container_range_1 {
    check "$(AVAX_ID_RPC=1 $(cmd) -i 0 -f 100 -e cb58 -b X -n tx)" ;
}

function test_index_get_container_range_2 {
    check "$(AVAX_ID_RPC=1 AVAX_START_INDEX=0 $(cmd) -f 100 -e cb58 -b X -n tx)" ;
}

function test_index_get_container_range_3 {
    check "$(AVAX_ID_RPC=1 AVAX_NUM_TO_FETCH=100 $(cmd) -i 0 -e cb58 -b X -n tx)" ;
}

function test_index_get_container_range_4 {
    check "$(AVAX_ID_RPC=1 AVAX_ENCODING=cb58 $(cmd) -i 0 -f 100 -b X -n tx)" ;
}

function test_index_get_container_range_5a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=X $(cmd) -i 0 -f 100 -e cb58 -n tx)" ;
}

function test_index_get_container_range_5b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=tx $(cmd) -i 0 -f 100 -e cb58 -b X)" ;
}

function test_index_get_container_range_5c {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=vtx $(cmd) -i 0 -f 100 -e cb58 -b X)" "X/vtx" ;
}

function test_index_get_container_range_6a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=P $(cmd) -i 0 -f 100 -e cb58 -n block)" "P/block" ;
}

function test_index_get_container_range_6b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=block $(cmd) -i 0 -f 100 -e cb58 -b P)" "P/block" ;
}

function test_index_get_container_range_7a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=C $(cmd) -i 0 -f 100 -e cb58 -n block)" "C/block" ;
}

function test_index_get_container_range_7b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=block $(cmd) -i 0 -f 100 -e cb58 -b C)" "C/block" ;
}

###############################################################################
###############################################################################
