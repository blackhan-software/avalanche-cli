#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh platform get-validators-at" ;
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
    expect_d+='"method":"platform.getValidatorsAt",' ;
    expect_d+='"params":{' ;
    expect_d+='"height":3,' ;
    expect_d+='"subnetID":'"$([ -n "$2" ] && echo "\"$2\"" || echo null)" ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_platform__get_validators_at_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) -H 3 -s SUBNET_ID)" SUBNET_ID ;
}

function test_platform__get_validators_at_1b {
    check "$(AVAX_ID_RPC=1 AVAX_HEIGHT=3 $(cmd) -s SUBNET_ID)" SUBNET_ID ;
}

function test_platform__get_validators_at_1c {
    check "$(AVAX_ID_RPC=1 AVAX_SUBNET_ID=SUBNET_ID $(cmd) -H 3)" SUBNET_ID ;
}

function test_platform__get_validators_at_1d {
    check "$(AVAX_ID_RPC=1 $(cmd) -H 3)" ;
}

###############################################################################
###############################################################################
