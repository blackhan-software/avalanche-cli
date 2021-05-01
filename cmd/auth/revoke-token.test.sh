#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh auth revoke-token" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'https://api.avax.network/ext/auth'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"auth.revokeToken",' ;
    expect_d+='"params":{' ;
    expect_d+='"password":"PASSWORD",' ;
    expect_d+='"token":"TOKEN"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_auth__revoke_token_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) -p PASSWORD -t TOKEN)" ;
}

function test_auth__revoke_token_1b {
    check "$(AVAX_ID_RPC=1 AVAX_AUTH_PASSWORD=PASSWORD $(cmd) -t TOKEN)" ;
}

function test_auth__revoke_token_1c {
    check "$(AVAX_ID_RPC=1 AVAX_TOKEN=TOKEN $(cmd) -p PASSWORD)" ;
}

###############################################################################
###############################################################################
