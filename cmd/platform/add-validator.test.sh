#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform add-validator" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'https://api.avax.network/ext/P'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"platform.addValidator",' ;
    expect_d+='"params":{' ;
    expect_d+='"nodeID":"NODE_ID",' ;
    expect_d+='"startTime":2000000000,' ;
    expect_d+='"endTime":3000000000,' ;
    expect_d+='"stakeAmount":1000,' ;
    expect_d+='"delegationFeeRate":10.0000,' ; ## 10.0000%
    expect_d+='"rewardAddress":"REWARD_ADDRESS",' ;
    expect_d+='"from":["P1","P2"],' ;
    expect_d+='"changeAddr":"A3",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__add_validator_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS -r 10 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1b {
    check "$(AVAX_ID_RPC=1 AVAX_NODE_ID=NODE_ID $(cmd) \
        -b 2000000000 -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS -r 10 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1c {
    check "$(AVAX_ID_RPC=1 AVAX_START_TIME=2000000000 $(cmd) \
        -i NODE_ID -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS -r 10 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1d {
    check "$(AVAX_ID_RPC=1 AVAX_END_TIME=3000000000 $(cmd) \
        -i NODE_ID -b 2000000000 \
        -# 1K -@ REWARD_ADDRESS -r 10 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1e {
    check "$(AVAX_ID_RPC=1 AVAX_STAKE_AMOUNT=1K $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -@ REWARD_ADDRESS -r 10 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1f {
    check "$(AVAX_ID_RPC=1 AVAX_USERNAME=USERNAME $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS -r 10 \
        -f P1 -f P2 -c A3 \
        -p PASSWORD)" ;
}

function test_platform__add_validator_1g {
    check "$(AVAX_ID_RPC=1 AVAX_REWARD_ADDRESS=REWARD_ADDRESS $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -r 10 \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1h {
    check "$(AVAX_ID_RPC=1 AVAX_DELEGATION_FEE_RATE=100000 $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1i {
    check "$(AVAX_ID_RPC=1 AVAX_REWARD_ADDRESS=REWARD_ADDRESS $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -r 10.0% \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1h {
    check "$(AVAX_ID_RPC=1 AVAX_DELEGATION_FEE_RATE=10.0% $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS \
        -f P1 -f P2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1i {
    check "$(AVAX_ID_RPC=1 \
        AVAX_FROM_ADDRESS_0=P1 AVAX_FROM_ADDRESS_1=P2 $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS -r 10 \
        -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_platform__add_validator_1j {
    check "$(AVAX_ID_RPC=1 AVAX_CHANGE_ADDRESS=A3 $(cmd) \
        -i NODE_ID -b 2000000000 -e 3000000000 \
        -# 1K -@ REWARD_ADDRESS -r 10 \
        -f P1 -f P2 \
        -u USERNAME -p PASSWORD)" ;
}

###############################################################################
###############################################################################
