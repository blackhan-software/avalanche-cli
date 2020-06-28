#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform add-default-subnet-validator" ;
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
    expect_d+='"method":"platform.addDefaultSubnetValidator",' ;
    expect_d+='"params":{' ;
    expect_d+='"id":"ID",' ;
    expect_d+='"startTime":2000000000,' ;
    expect_d+='"endTime":3000000000,' ;
    expect_d+='"stakeAmount":1000,' ;
    expect_d+='"payerNonce":3,' ;
    expect_d+='"destination":"DESTINATION",' ;
    expect_d+='"delegationFeeRate":100000' ; ## 10%
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__add_default_subnet_validator_1a {
    check "$(RPC_ID=1 $(cmd) \
        -i ID -b 2000000000 -e 3000000000 \
        -# 1K -% 3 -@ DESTINATION -r 100000)" ;
}

function test_platform__add_default_subnet_validator_1b {
    check "$(RPC_ID=1 AVA_ID=ID $(cmd) \
        -b 2000000000 -e 3000000000 \
        -# 1K -% 3 -@ DESTINATION -r 100000)" ;
}

function test_platform__add_default_subnet_validator_1c {
    check "$(RPC_ID=1 AVA_START_TIME=2000000000 $(cmd) \
        -i ID -e 3000000000 \
        -# 1K -% 3 -@ DESTINATION -r 100000)" ;
}

function test_platform__add_default_subnet_validator_1d {
    check "$(RPC_ID=1 AVA_END_TIME=3000000000 $(cmd) \
        -i ID -b 2000000000 \
        -# 1K -% 3 -@ DESTINATION -r 100000)" ;
}

function test_platform__add_default_subnet_validator_1e {
    check "$(RPC_ID=1 AVA_STAKE_AMOUNT=1K $(cmd) \
        -i ID -b 2000000000 -e 3000000000 \
        -% 3 -@ DESTINATION -r 100000)" ;
}

function test_platform__add_default_subnet_validator_1f {
    check "$(RPC_ID=1 AVA_PAYER_NONCE=3 $(cmd) \
        -i ID -b 2000000000 -e 3000000000 \
        -# 1K -@ DESTINATION -r 100000)" ;
}

function test_platform__add_default_subnet_validator_1g {
    check "$(RPC_ID=1 AVA_DESTINATION=DESTINATION $(cmd) \
        -i ID -b 2000000000 -e 3000000000 \
        -# 1K -% 3 -r 100000)" ;
}

function test_platform__add_default_subnet_validator_1h {
    check "$(RPC_ID=1 AVA_DELEGATION_FEE_RATE=100000 $(cmd) \
        -i ID -b 2000000000 -e 3000000000 \
        -# 1K -% 3 -@ DESTINATION)" ;
}

###############################################################################
###############################################################################
