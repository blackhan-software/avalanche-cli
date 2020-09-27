#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform create-subnet" ;
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
    expect_d+='"method":"platform.createSubnet",' ;
    expect_d+='"params":{' ;
    expect_d+='"controlKeys":["K1","K2","K3"],' ;
    expect_d+='"threshold":2,' ;
    expect_d+='"from":["P1","P2"],' ;
    expect_d+='"changeAddr":"A3",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__create_subnet_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -@ K1 -@ K2 -@ K3 -t 2 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_subnet_1b {
    check "$(AVAX_ID_RPC=1 AVAX_CONTROL_KEY_0=K1 $(cmd) \
        -@ K2 -@ K3 -t 2 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
    check "$(AVAX_ID_RPC=1 \
        AVAX_CONTROL_KEY_0=K1 AVAX_CONTROL_KEY_1=K2 $(cmd) \
        -@ K3 -t 2 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
    check "$(AVAX_ID_RPC=1 \
        AVAX_CONTROL_KEY_0=K1 AVAX_CONTROL_KEY_1=K2 AVAX_CONTROL_KEY_2=K3 $(cmd) \
        -t 2 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_subnet_1c {
    check "$(AVAX_ID_RPC=1 AVAX_THRESHOLD=2 $(cmd) \
        -@ K1 -@ K2 -@ K3 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_subnet_1d {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -@ K1 -@ K2 -@ K3 -t 2 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_subnet_1e {
    check "$(AVAX_ID_RPC=1 \
        AVAX_FROM_ADDRESS_0=P1 AVAX_FROM_ADDRESS_1=P2 $(cmd) \
        -@ K1 -@ K2 -@ K3 -t 2 \
        -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__create_subnet_1f {
    check "$(AVAX_ID_RPC=1 AVAX_CHANGE_ADDRESS=A3 $(cmd) \
        -@ K1 -@ K2 -@ K3 -t 2 \
        -f P1 -f P2 \
        -u USERNAME -p PASSWORD)" ;
}

###############################################################################
###############################################################################
