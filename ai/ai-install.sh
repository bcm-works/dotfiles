#!/usr/bin/env bash
#
#
# Install and update AI Code Generation tools
#  - To run this script:
#    - Clone this repo
#    - Open that dir in Terminal
#    - Run: bash ./ai/ai-install.sh
#  - Uses the first-party suggested installation and update commands for Linux/macOS
#  - Assumes that Homebrew is already installed
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"

# Google Antigravity CLI - https://antigravity.google/product/antigravity-cli

if ! command -v agy > /dev/null 2>&1 ; then
  info 'Install: Google Antigravity CLI'
  curl -fsSL https://antigravity.google/cli/install.sh | bash > /dev/null 2>&1
fi

info 'Update: Google Antigravity CLI'
agy update > /dev/null 2>&1

# OpenAI Codex CLI - https://developers.openai.com/codex/cli

if ! command -v codex > /dev/null 2>&1 ; then
  info 'Install: OpenAI Codex CLI'
  brew install codex > /dev/null 2>&1

  info 'Update: OpenAI Codex CLI'
  brew upgrade codex > /dev/null 2>&1
else
  info 'Update: OpenAI Codex CLI'
  codex update > /dev/null 2>&1
fi

# Claude Code CLI - https://code.claude.com/docs/en/quickstart

if ! command -v claude > /dev/null 2>&1 ; then
  info 'Install: Claude Code CLI'
  curl -fsSL https://claude.ai/install.sh | bash > /dev/null 2>&1
fi

info 'Update: Claude Code CLI'
claude update > /dev/null 2>&1

# GitHub Copilot CLI - https://github.com/features/copilot/cli

if ! command -v copilot > /dev/null 2>&1 ; then
  info 'Install: GitHub Copilot CLI'
  curl -fsSL https://gh.io/copilot-install | bash > /dev/null 2>&1
fi

info 'Update: GitHub Copilot CLI'
copilot update > /dev/null 2>&1
