#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/array.sh" ;

###############################################################################

function test_map_by_0 {
    local -a MY_ARRAY ;
    assertEquals "" "$(map_by '"%s",' "${MY_ARRAY[@]}")" ;
}

function test_map_by_1 {
    local -a MY_ARRAY=( a ) ;
    assertEquals '"a",' "$(map_by '"%s",' "${MY_ARRAY[@]}")" ;
}

function test_map_by_2 {
    local -a MY_ARRAY=( a b ) ;
    assertEquals '"a","b",' "$(map_by '"%s",' "${MY_ARRAY[@]}")" ;
}

function test_map_by_3 {
    local -a MY_ARRAY=( a b c ) ;
    assertEquals '"a","b","c",' "$(map_by '"%s",' "${MY_ARRAY[@]}")" ;
}

function test_map_by_d {
    local -a MY_ARRAY=( 0 1 2 ) ;
    assertEquals '"00","01","02",' "$(map_by '"%0.2d",' "${MY_ARRAY[@]}")" ;
}

###############################################################################

function test_join_by_0 {
    local -a MY_ARRAY ;
    assertEquals "" "$(join_by ', ' "${MY_ARRAY[@]}")" ;
}

function test_join_by_1 {
    local -a MY_ARRAY=( a ) ;
    assertEquals "a" "$(join_by ', ' "${MY_ARRAY[@]}")" ;
}

function test_join_by_2 {
    local -a MY_ARRAY=( a b ) ;
    assertEquals "a, b" "$(join_by ', ' "${MY_ARRAY[@]}")" ;
}

function test_join_by_3 {
    local -a MY_ARRAY=( a b c ) ;
    assertEquals "a, b, c" "$(join_by ', ' "${MY_ARRAY[@]}")" ;
}

function test_join_by_d {
    local -a MY_ARRAY=( 0 1 2 ) ;
    assertEquals "0, 1, 2" "$(join_by ', ' "${MY_ARRAY[@]}")" ;
}

###############################################################################

function test_zip_by_00_yes_supported {
    local -a MY_A MY_B ;
    assertEquals '' "$(\
        zip_by '"%s":"%s" ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_01_not_supported {
    local -a MY_A=( ) MY_B=( 1 ) ;
    assertNotEquals '"":1 ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_10_but_supported {
    local -a MY_A=( a ) MY_B=( ) ;
    assertEquals '"a": ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_11_yes_supported {
    local -a MY_A=( a ) MY_B=( 1 ) ;
    assertEquals '"a":1 ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_12_not_supported {
    local -a MY_A=( a ) MY_B=( 1 2 ) ;
    assertNotEquals '"":1 "b":2 ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_21_but_supported {
    local -a MY_A=( a b ) MY_B=( 1 ) ;
    assertEquals '"a":1 "b": ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_22_yes_supported {
    local -a MY_A=( a b ) MY_B=( 1 2 ) ;
    assertEquals '"a":1 "b":2 ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_13_not_supported {
    local -a MY_A=( a ) MY_B=( 1 2 3 ) ;
    assertNotEquals '"a":1 "":2 "":3 ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_23_not_supported {
    local -a MY_A=( a b ) MY_B=( 1 2 3 ) ;
    assertNotEquals '"a":1 "b":2 "":3 ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_31_not_supported {
    local -a MY_A=( a b c ) MY_B=( 1 ) ;
    assertNotEquals '"a":1 "b": "c": ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_32_but_supported {
    local -a MY_A=( a b c ) MY_B=( 1 2 ) ;
    assertEquals '"a":1 "b":2 "c": ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_33_yes_supported {
    local -a MY_A=( a b c ) MY_B=( 1 2 3 ) ;
    assertEquals '"a":1 "b":2 "c":3 ' "$(\
        zip_by '"%s":%s ' "${MY_A[@]}" "${MY_B[@]}")" ;
}

###############################################################################

function test_zip_by_n__00 {
    local -a MY_A MY_B ;
    assertEquals '' "$(zip_by_n '"%s":%s ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__01 {
    local -a MY_A=( ) MY_B=( 1 ) ;
    assertEquals '"":1 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__10 {
    local -a MY_A=( a ) MY_B=( ) ;
    assertEquals '"a":0 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__11 {
    local -a MY_A=( a ) MY_B=( 1 ) ;
    assertEquals '"a":1 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__12 {
    local -a MY_A=( a ) MY_B=( 1 2 ) ;
    assertEquals '"a":1 "":2 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__21 {
    local -a MY_A=( a b ) MY_B=( 1 ) ;
    assertEquals '"a":1 "b":0 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__22 {
    local -a MY_A=( a b ) MY_B=( 1 2 ) ;
    assertEquals '"a":1 "b":2 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__30 {
    local -a MY_A=( a b c ) MY_B=( ) ;
    assertEquals '"a":0 "b":0 "c":0 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__31 {
    local -a MY_A=( a b c ) MY_B=( 1 ) ;
    assertEquals '"a":1 "b":0 "c":0 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__32 {
    local -a MY_A=( a b c ) MY_B=( 1 2 ) ;
    assertEquals '"a":1 "b":2 "c":0 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

function test_zip_by_n__33 {
    local -a MY_A=( a b c ) MY_B=( 1 2 3 ) ;
    assertEquals '"a":1 "b":2 "c":3 ' "$(zip_by_n '"%s":%d ' \
        "${#MY_A[@]}" "${MY_A[@]}" "${#MY_B[@]}" "${MY_B[@]}")" ;
}

###############################################################################

function test_next_index_0a {
    local -a INDICES ;
    # INDICES[0]=0 ;
    assertEquals "0" "$(next_index INDICES)" ;
}

function test_next_index_0b {
    local -a INDICES ;
    INDICES[0]=0 ;
    assertEquals "1" "$(next_index INDICES)" ;
}

function test_next_index_1a {
    local -a INDICES ;
    # INDICES[0]=0 ;
    INDICES[1]=1 ;
    assertEquals "0" "$(next_index INDICES)" ;
}

function test_next_index_1b {
    local -a INDICES ;
    INDICES[0]=0 ;
    INDICES[1]=1 ;
    assertEquals "2" "$(next_index INDICES)" ;
}

function test_next_index_2a {
    local -a INDICES ;
    INDICES[0]=0 ;
    # INDICES[1]=1 ;
    INDICES[2]=2 ;
    assertEquals "1" "$(next_index INDICES)" ;
}

function test_next_index_2b {
    local -a INDICES ;
    INDICES[0]=0 ;
    INDICES[1]=1 ;
    INDICES[2]=2 ;
    assertEquals "3" "$(next_index INDICES)" ;
}

function test_next_index_3a {
    local -a INDICES ;
    INDICES[0]=0 ;
    INDICES[1]=1 ;
    # INDICES[2]=2 ;
    INDICES[3]=3 ;
    assertEquals "2" "$(next_index INDICES)" ;
}

function test_next_index_3b {
    local -a INDICES ;
    INDICES[0]=0 ;
    INDICES[1]=1 ;
    INDICES[2]=2 ;
    INDICES[3]=3 ;
    assertEquals "4" "$(next_index INDICES)" ;
}

###############################################################################
###############################################################################
