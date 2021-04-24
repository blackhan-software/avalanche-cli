#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh index get-container-by-index" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/index/${2-X/tx}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"index.getContainerByIndex",' ;
    expect_d+='"params":{' ;
    expect_d+='"index":0,' ;
    expect_d+='"encoding":"cb58"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_index_get_container_by_index_0 {
    check "$(AVAX_ID_RPC=1 $(cmd) -i 0)" ;
}

function test_index_get_container_by_index_1 {
    check "$(AVAX_ID_RPC=1 $(cmd) -i 0 -e cb58 -b X -n tx)" ;
}

function test_index_get_container_by_index_2 {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX=0 $(cmd) -e cb58 -b X -n tx)" ;
}

function test_index_get_container_by_index_3 {
    check "$(AVAX_ID_RPC=1 AVAX_ENCODING=cb58 $(cmd) -i 0 -b X -n tx)" ;
}

function test_index_get_container_by_index_4a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=X $(cmd) -i 0 -e cb58 -n tx)" ;
}

function test_index_get_container_by_index_4b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=tx $(cmd) -i 0 -e cb58 -b X)" ;
}

function test_index_get_container_by_index_4c {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=vtx $(cmd) -i 0 -e cb58 -b X)" "X/vtx" ;
}

function test_index_get_container_by_index_5a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=P $(cmd) -i 0 -e cb58 -n block)" "P/block" ;
}

function test_index_get_container_by_index_5b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=block $(cmd) -i 0 -e cb58 -b P)" "P/block" ;
}

function test_index_get_container_by_index_6a {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=C $(cmd) -i 0 -e cb58 -n block)" "C/block" ;
}

function test_index_get_container_by_index_6b {
    check "$(AVAX_ID_RPC=1 AVAX_INDEX_NAME=block $(cmd) -i 0 -e cb58 -b C)" "C/block" ;
}

###############################################################################
###############################################################################
