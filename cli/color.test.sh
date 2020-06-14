#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/color.sh" ;

###############################################################################

function test_color_bb {
    assertNotNull "$BB" ;
}

function test_color_ub {
    assertNotNull "$UB" ;
}

function test_color_ul {
    assertNotNull "$UL" ;
}

function test_color_ub {
    assertNotNull "$NL" ;
}

function test_color_lk {
    assertNotNull "$LK" ;
}

function test_color_nn {
    assertNotNull "$NN" ;
}

###############################################################################
###############################################################################
