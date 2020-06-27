#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################
CMD_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avm build-genesis" ;
}

function data {
    cat "$CMD_SCRIPT/build-genesis.test.json" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/vm/avm'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"avm.buildGenesis",' ;
    expect_d+='"params":{' ;
    expect_d+='"genesisData":'"$(data)" ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__get_build_genesis_1a {
    check "$(RPC_ID=1 $(cmd) -g "$(data)")" ;
}

function test_avm__get_build_genesis_1b {
    check "$(RPC_ID=1 AVA_GENESIS_DATA="$(data)" $(cmd))" ;
}

###############################################################################
###############################################################################
