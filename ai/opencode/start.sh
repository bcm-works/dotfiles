#!/usr/bin/env bash
#
#
# Run OpenCode CLI with project specific config.
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$REPO/cli"
OPENCODE="$REPO/.opencode"

CLI_CONFIG=$(cat "$OPENCODE/cli.json")

OPENCODE_CLI_CONFIG_CONTENT=$CLI_CONFIG \
  opencode

