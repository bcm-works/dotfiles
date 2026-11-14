#!/usr/bin/env bash
#
#
# Run the OpenCode CLI tool using project specific config
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"

CFG=$(cat "$REPO/.opencode/cli.json")

OPENCODE_CLI_CONFIG_CONTENT=$CFG opencode

