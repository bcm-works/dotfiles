#!/usr/bin/env bash
#
#
# Install and update AI Code Generation tools
#  - Uses the first-party suggested installation and update commands for Linux/macOS
#  - Requires Homebrew to be installed
#  - To run this script:
#    - Clone this repo
#    - Open that dir in a new terminal
#    - Run: bash ./bin/setup.sh
#    - Run: bash ./ai/ai-install.sh
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  warn "Please manually install the AI Code Generation tools you need."
  echo ''
  info " - Google Antigravity CLI - https://antigravity.google/product/antigravity-cli"
  info " - OpenAI Codex CLI - https://developers.openai.com/codex/cli"
  info " - Claude Code CLI - https://code.claude.com/docs/en/quickstart"
  info " - GitHub Copilot CLI - https://github.com/features/copilot/cli"
  exit 1
fi

# Google Antigravity CLI - https://antigravity.google/product/antigravity-cli

if [ ! "$(command -v agy)" ]; then
  info 'Install: Google Antigravity CLI'
  curl -fsSL https://antigravity.google/cli/install.sh | bash > /dev/null 2>&1
else
	info 'Update: Google Antigravity CLI'
	agy update > /dev/null 2>&1
fi

# OpenAI Codex CLI - https://developers.openai.com/codex/cli

if [ ! "$(command -v codex)" ]; then
  info 'Install: OpenAI Codex CLI'
  brew install codex > /dev/null 2>&1
else
  info 'Update: OpenAI Codex CLI'
  codex update > /dev/null 2>&1
fi

# Claude Code CLI - https://code.claude.com/docs/en/quickstart

if [ ! "$(command -v claude)" ];  then
  info 'Install: Claude Code CLI'
  curl -fsSL https://claude.ai/install.sh | bash > /dev/null 2>&1
else
	info 'Update: Claude Code CLI'
	claude update > /dev/null 2>&1
fi

# GitHub Copilot CLI - https://github.com/features/copilot/cli

if [ ! "$(command -v copilot)" ];  then
  info 'Install: GitHub Copilot CLI'
  curl -fsSL https://gh.io/copilot-install | bash > /dev/null 2>&1
else
	info 'Update: GitHub Copilot CLI'
	copilot update > /dev/null 2>&1
fi
