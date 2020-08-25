#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform sign" ;
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
    expect_d+='"method":"platform.sign",' ;
    expect_d+='"params":{' ;
    expect_d+='"tx":"TX",' ;
    expect_d+='"signer":"ADDRESS",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__sign_1a {
    check "$(AVAX_ID_RPC=1 \
        $(cmd) -t TX -@ ADDRESS -u USERNAME -p PASSWORD)" ;
}

function test_platform__sign_1b {
    check "$(AVAX_ID_RPC=1 AVAX_TX=TX \
        $(cmd) -@ ADDRESS -u USERNAME -p PASSWORD)" ;
}

function test_platform__sign_1c {
    check "$(AVAX_ID_RPC=1 AVAX_SIGNER=ADDRESS \
        $(cmd) -t TX -u USERNAME -p PASSWORD)" ;
}

function test_platform__sign_1d {
    check "$(AVAX_ID_RPC=1 AVAX_USERNAME=USERNAME \
        $(cmd) -t TX -@ ADDRESS -p PASSWORD)" ;
}

function test_platform__sign_1e {
    check "$(AVAX_ID_RPC=1 AVAX_PASSWORD=PASSWORD \
        $(cmd) -t TX -@ ADDRESS -u USERNAME)" ;
}

###############################################################################
###############################################################################
