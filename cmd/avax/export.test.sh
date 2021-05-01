#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avax export" ;
}

function check {
    local result="$1";
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'https://api.avax.network/ext/bc/C/avax'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"avax.export",' ;
    expect_d+='"params":{' ;
    expect_d+='"to":"TO",' ;
    expect_d+='"amount":1000000,' ;
    expect_d+='"assetID":"ASSET_ID",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avax__export_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -@TO -#1M -a ASSET_ID -u USERNAME -p PASSWORD)" ;
}

function test_avax__export_1b {
    check "$(AVAX_ID_RPC=1 AVAX_TO=TO $(cmd) \
        -#1M -a ASSET_ID -u USERNAME -p PASSWORD)" ;
}

function test_avax__export_1c {
    check "$(AVAX_ID_RPC=1 AVAX_AMOUNT=1M $(cmd) \
        -@TO -a ASSET_ID -u USERNAME -p PASSWORD)" ;
}

function test_avax__export_1d {
    check "$(AVAX_ID_RPC=1 AVAX_ASSET_ID=ASSET_ID $(cmd) \
        -@TO -#1M -u USERNAME -p PASSWORD)" ;
}

function test_avax__export_1e {
    check "$(AVAX_ID_RPC=1 AVAX_USERNAME=USERNAME $(cmd) \
        -@TO -#1M -a ASSET_ID -p PASSWORD)" ;
}

function test_avax__export_1f {
    check "$(AVAX_ID_RPC=1 AVAX_PASSWORD=PASSWORD $(cmd) \
        -@TO -#1M -a ASSET_ID -u USERNAME)" ;
}

###############################################################################
###############################################################################
