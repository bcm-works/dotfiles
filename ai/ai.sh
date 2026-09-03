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
#    - Run: bash ./ai/ai.sh
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  warn "Please manually install the AI Code Generation tools you need."
  echo ''
  info " - Ollama - https://ollama.com/"
  info " - OpenCode - https://opencode.ai/"
  info " - Google Antigravity - https://antigravity.google/product/antigravity-cli"
  info " - OpenAI Codex - https://developers.openai.com/codex/cli"
  info " - Claude Code - https://code.claude.com/docs/en/quickstart"
  info " - GitHub Copilot - https://github.com/features/copilot/cli"
  exit 0
fi

# Ollama - https://ollama.com/

if [ ! "$(command -v ollama)" ]; then
	info 'Installing Ollama'
else
	info 'Updating Ollama'
fi
curl -fsSL https://ollama.com/install.sh | bash > /dev/null 2>&1

# OpenCode - https://opencode.ai/

if [ ! "$(command -v opencode)" ]; then
	info 'Installing OpenCode'
	curl -fsSL https://opencode.ai/install | bash > /dev/null 2>&1
else
	info 'Updating OpenCode'
	opencode upgrade --method curl > /dev/null 2>&1
fi

# Google Antigravity - https://antigravity.google/product/antigravity-cli

if [ ! "$(command -v agy)" ]; then
  info 'Installing Google Antigravity'
  curl -fsSL https://antigravity.google/cli/install.sh | bash > /dev/null 2>&1
else
	info 'Updating Google Antigravity'
	agy update > /dev/null 2>&1
fi

# OpenAI Codex - https://developers.openai.com/codex/cli

if [ ! "$(command -v codex)" ]; then
  info 'Installing OpenAI Codex'
  brew install codex > /dev/null 2>&1
else
  info 'Updating OpenAI Codex'
  codex update > /dev/null 2>&1
fi

# Claude Code - https://code.claude.com/docs/en/quickstart

if [ ! "$(command -v claude)" ];  then
  info 'Installing Claude Code'
  curl -fsSL https://claude.ai/install.sh | bash > /dev/null 2>&1
else
	info 'Updating Claude Code'
	claude update > /dev/null 2>&1
fi

# GitHub Copilot - https://github.com/features/copilot/cli

if [ ! "$(command -v copilot)" ];  then
  info 'Installing GitHub Copilot'
  curl -fsSL https://gh.io/copilot-install | bash > /dev/null 2>&1
else
	info 'Updating GitHub Copilot'
	copilot update > /dev/null 2>&1
fi
