#!/usr/bin/env bash
# shellcheck disable=SC2091
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avm get-asset-description" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'https://api.avax.network/ext/bc/${2-X}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"avm.getAssetDescription",' ;
    expect_d+='"params":{' ;
    expect_d+='"assetID":"ASSET_ID"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__get_asset_description_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) -a ASSET_ID)" ;
}

function test_avm__get_asset_description_1b {
    check "$(AVAX_ID_RPC=1 AVAX_ASSET_ID=ASSET_ID $(cmd))" ;
}

function test_avm__get_asset_description_2a {
    check "$(AVAX_ID_RPC=1 $(cmd) -a ASSET_ID -b BC_ID)" BC_ID ;
}

function test_avm__get_asset_description_2b {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=BC_ID $(cmd) -a ASSET_ID)" BC_ID ;
}

###############################################################################
###############################################################################
