#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avm send-nft" ;
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
    expect_d+='"method":"avm.sendNFT",' ;
    expect_d+='"params":{' ;
    expect_d+='"assetID":"ASSET_ID",' ;
    expect_d+='"groupID":"GROUP_ID",' ;
    expect_d+='"to":"TO",' ;
    expect_d+='"from":["A1","A2"],' ;
    expect_d+='"changeAddr":"A3",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__send_nft_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -a ASSET_ID -g GROUP_ID \
        -@ TO -f A1 -f A2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_avm__send_nft_1b {
    check "$(AVAX_ID_RPC=1 \
        AVAX_ASSET_ID=ASSET_ID AVAX_GROUP_ID=GROUP_ID $(cmd) \
        -@ TO -f A1 -f A2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_avm__send_nft_1c {
    check "$(AVAX_ID_RPC=1 AVAX_USERNAME=USERNAME $(cmd) \
        -a ASSET_ID -g GROUP_ID \
        -@ TO -f A1 -f A2 -c A3 -p PASSWORD)" ;
}

function test_avm__send_nft_1d {
    check "$(AVAX_ID_RPC=1 AVAX_PASSWORD=PASSWORD $(cmd) \
        -a ASSET_ID -g GROUP_ID \
        -@ TO -f A1 -f A2 -c A3 \
        -u USERNAME)" ;
}

function test_avm__send_nft_1e {
    check "$(AVAX_ID_RPC=1 \
        AVAX_FROM_ADDRESS_0=A1 AVAX_FROM_ADDRESS_1=A2 $(cmd) \
        -a ASSET_ID -g GROUP_ID \
        -@ TO -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_avm__send_nft_1f {
    check "$(AVAX_ID_RPC=1 \
        AVAX_CHANGE_ADDRESS=A3 $(cmd) \
        -a ASSET_ID -g GROUP_ID \
        -@ TO -f A1 -f A2 \
        -u USERNAME -p PASSWORD)" ;
}

function test_avm__send_nft_2a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -a ASSET_ID -g GROUP_ID \
        -@ TO -f A1 -f A2 -c A3 \
        -u USERNAME -p PASSWORD -b BC_ID \
    )" BC_ID ;
}

function test_avm__send_nft_2b {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=BC_ID $(cmd) \
        -a ASSET_ID -g GROUP_ID \
        -@ TO -f A1 -f A2 -c A3 \
        -u USERNAME -p PASSWORD \
    )" BC_ID ;
}

###############################################################################
###############################################################################
