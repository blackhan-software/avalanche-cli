#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/si-suffix.sh" ;

###############################################################################

function test_si_unit {
    assertEquals "1" "$(si "1")" ;
    # 10^0:       0
}

function test_si_kilo {
    assertEquals "1000" "$(si "1K")" ;
    # 10^3:       0123
}

function test_si_mega {
    assertEquals "1000000" "$(si "1M")" ;
    # 10^6:       0123456
}

function test_si_giga {
    assertEquals "1000000000" "$(si "1G")" ;
    # 10^9:       0123456789
}

function test_si_tera {
    assertEquals "1000000000000" "$(si "1T")" ;
    # 10^12:      0123456789012
}

function test_si_peta {
    assertEquals "1000000000000000" "$(si "1P")" ;
    # 10^15:      0123456789012345
}

function test_si_exa {
    assertEquals "1000000000000000000" "$(si "1E")" ;
    # 10^18:      0123456789012345678
}

function test_si_zetta {
    assertEquals "1000000000000000000000" "$(si "1Z")" ;
    # 10^21:      0123456789012345678901
}

function test_si_yotta {
    assertEquals "1000000000000000000000000" "$(si "1Y")" ;
    # 10^24:      0123456789012345678901234
}

###############################################################################
###############################################################################
