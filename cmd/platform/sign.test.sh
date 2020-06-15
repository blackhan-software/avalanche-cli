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
    check "$(RPC_ID=1 \
        $(cmd) -t TX -a ADDRESS -u USERNAME -p PASSWORD)" ;
}

function test_platform__sign_1b {
    check "$(RPC_ID=1 AVA_TX=TX \
        $(cmd) -a ADDRESS -u USERNAME -p PASSWORD)" ;
}

function test_platform__sign_1c {
    check "$(RPC_ID=1 AVA_SIGNER=ADDRESS \
        $(cmd) -t TX -u USERNAME -p PASSWORD)" ;
}

function test_platform__sign_1d {
    check "$(RPC_ID=1 AVA_USERNAME=USERNAME \
        $(cmd) -t TX -a ADDRESS -p PASSWORD)" ;
}

function test_platform__sign_1e {
    check "$(RPC_ID=1 AVA_PASSWORD=PASSWORD \
        $(cmd) -t TX -a ADDRESS -u USERNAME)" ;
}

###############################################################################
###############################################################################
