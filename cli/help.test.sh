#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/help.sh" ;

###############################################################################

function test_command_help {
    assertNotNull "$(cli_help)" ;
}

function test_command_help_admin {
    local text; text="$(cli_help admin)" ;
    assertContains "$text" "Admin API" ;
}

function test_command_help_avm {
    local text; text="$(cli_help avm)" ;
    assertContains "$text" "Exchange Chain (X-Chain) API" ;
}

function test_command_help_avm_wallet {
    local text; text="$(cli_help wallet)" ;
    assertContains "$text" "Exchange Chain (X-Chain) Wallet API" ;
}

function test_command_help_evm {
    local text; text="$(cli_help evm)" ;
    assertContains "$text" "Contract Chain (C-Chain) API" ;
}

function test_command_help_evm_avax {
    local text; text="$(cli_help avax)" ;
    assertContains "$text" "Contract Chain (C-Chain) AVAX API" ;
}

function test_command_help_health {
    local text; text="$(cli_help health)" ;
    assertContains "$text" "Health API" ;
}

function test_command_help_info {
    local text; text="$(cli_help info)" ;
    assertContains "$text" "Info API" ;
}

function test_command_help_ipcs {
    local text; text="$(cli_help ipcs)" ;
    assertContains "$text" "IPC API" ;
}

function test_command_help_keystore {
    local text; text="$(cli_help keystore)" ;
    assertContains "$text" "Keystore API" ;
}

function test_command_help_metrics {
    local text; text="$(cli_help metrics)" ;
    assertContains "$text" "Metrics API" ;
}

function test_command_help_platform {
    local text; text="$(cli_help platform)" ;
    assertContains "$text" "Platform Chain (P-Chain) API" ;
}

###############################################################################
###############################################################################
