#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform add-subnet-validator" ;
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
    expect_d+='"method":"platform.addSubnetValidator",' ;
    expect_d+='"params":{' ;
    expect_d+='"nodeID":"NODE_ID",' ;
    expect_d+='"subnetID":"SUBNET_ID",' ;
    expect_d+='"startTime":2000000000,' ;
    expect_d+='"endTime":3000000000,' ;
    expect_d+='"weight":1,' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__add_subnet_validator_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -i NODE_ID -s SUBNET_ID -b 2000000000 -e 3000000000 -w 1 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_subnet_validator_1b {
    check "$(AVAX_ID_RPC=1 AVAX_NODE_ID=NODE_ID $(cmd) \
        -s SUBNET_ID -b 2000000000 -e 3000000000 -w 1 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_subnet_validator_1c {
    check "$(AVAX_ID_RPC=1 AVAX_START_TIME=2000000000 $(cmd) \
        -i NODE_ID -s SUBNET_ID -e 3000000000 -w 1 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_subnet_validator_1d {
    check "$(AVAX_ID_RPC=1 AVAX_END_TIME=3000000000 $(cmd) \
        -i NODE_ID -s SUBNET_ID -b 2000000000 -w 1 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_subnet_validator_1e {
    check "$(AVAX_ID_RPC=1 AVAX_WEIGHT=1 $(cmd) \
        -i NODE_ID -s SUBNET_ID -b 2000000000 -e 3000000000 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_subnet_validator_1f {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -i NODE_ID -s SUBNET_ID -b 2000000000 -e 3000000000 -w 1 \
        -u USERNAME -p PASSWORD)" ;
}

###############################################################################
###############################################################################
