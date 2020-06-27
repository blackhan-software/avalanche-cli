#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform export-ava" ;
}

function check {
    local result="$1";
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
    expect_d+='"method":"platform.exportAVA",' ;
    expect_d+='"params":{' ;
    expect_d+='"amount":999,' ;
    expect_d+='"to":"TO",' ;
    expect_d+='"payerNonce":3' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__export_ava_1a {
    check "$(RPC_ID=1 $(cmd) -# 999 -@ TO -% 3)" ;
}

function test_platform__export_ava_1b {
    check "$(RPC_ID=1 AVA_AMOUNT=999 $(cmd) -@ TO -% 3)" ;
}

function test_platform__export_ava_1c {
    check "$(RPC_ID=1 AVA_TO=TO $(cmd) -# 999 -% 3)" ;
}

function test_platform__export_ava_1d {
    check "$(RPC_ID=1 AVA_PAYER_NONCE=3 $(cmd) -# 999 -@ TO)" ;
}

###############################################################################
###############################################################################
