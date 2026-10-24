#!/usr/bin/env bash
#
#
# Install and update AI Code Generation tools
#  - Uses the first-party suggested installation and update commands for Linux/macOS
#  - Requires Homebrew to be installed
#  - To run this script:
#    - Clone this repo
#    - Open that dir in a new terminal
#    - Run: bash ./setup.sh
#    - Run: bash ./ai/ai.sh
#  - To install one AI tool only (eg opencode), run: bash ./ai/ai.sh opencode
#
#

source "$HOME/Dotfiles/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"

if [[ $# -eq 0 ]]; then
  echo 'AI Code Generation Tools installer.'
  echo ''
  echo 'Usage: bash ./ai/ai.sh [opencode|agy|codex|claude|copilot]'
  echo ''
  echo 'Options:'
  echo '  opencode  Install or update OpenCode'
  echo '  agy       Install or update Google Antigravity'
  echo '  codex     Install or update OpenAI Codex'
  echo '  claude    Install or update Claude Code'
  echo '  copilot   Install or update GitHub Copilot'
  echo ''

  read -r -p 'Install or update all of the above AI tools now? [y/N] ' ANSWER
  if [[ ! "$ANSWER" =~ ^[Yy]$ ]]; then
		echo 'Cancelled install'
    exit 0
  fi

  TARGET='all'
else
  TARGET="$1"
fi

cd "$REPO"

if [[ $# -gt 1 ]]; then
  error "Only one AI tool can be selected."
  exit 1
fi

case "$TARGET" in
  all|opencode|agy|codex|claude|copilot) ;;
  *)
    error "Unknown AI tool: $TARGET"
    info 'Valid options: opencode, agy, codex, claude, copilot'
    exit 1
    ;;
esac

if [[ "$OS" == "Windows" ]]; then
  warn "Please manually install the AI Code Generation tools you need."
  echo ''
  info " - OpenCode - https://opencode.ai/"
  info " - Google Antigravity - https://antigravity.google/product/antigravity-cli"
  info " - OpenAI Codex - https://developers.openai.com/codex/cli"
  info " - Claude Code - https://code.claude.com/docs/en/quickstart"
  info " - GitHub Copilot - https://github.com/features/copilot/cli"

  exit 0
fi

# OpenCode - https://opencode.ai/

if [[ "$TARGET" == "all" || "$TARGET" == "opencode" ]] && [ ! "$(command -v opencode)" ]; then
	info 'Installing OpenCode'
	curl -fsSL https://opencode.ai/v2/install | bash > /dev/null 2>&1
elif [[ "$TARGET" == "all" || "$TARGET" == "opencode" ]]; then
	info 'Updating OpenCode'
	opencode upgrade --method curl > /dev/null 2>&1
fi

# Google Antigravity - https://antigravity.google/product/antigravity-cli

if [[ "$TARGET" == "all" || "$TARGET" == "agy" ]] && [ ! "$(command -v agy)" ]; then
  info 'Installing Google Antigravity'
  curl -fsSL https://antigravity.google/cli/install.sh | bash > /dev/null 2>&1
elif [[ "$TARGET" == "all" || "$TARGET" == "agy" ]]; then
	info 'Updating Google Antigravity'
	agy update > /dev/null 2>&1
fi

# OpenAI Codex - https://developers.openai.com/codex/cli

if [[ "$TARGET" == "all" || "$TARGET" == "codex" ]] && [ ! "$(command -v codex)" ]; then
  info 'Installing OpenAI Codex'
  brew install codex > /dev/null 2>&1
elif [[ "$TARGET" == "all" || "$TARGET" == "codex" ]]; then
  info 'Updating OpenAI Codex'
  codex update > /dev/null 2>&1
fi

# Claude Code - https://code.claude.com/docs/en/quickstart

if [[ "$TARGET" == "all" || "$TARGET" == "claude" ]] && [ ! "$(command -v claude)" ]; then
  info 'Installing Claude Code'
  curl -fsSL https://claude.ai/install.sh | bash > /dev/null 2>&1
elif [[ "$TARGET" == "all" || "$TARGET" == "claude" ]]; then
	info 'Updating Claude Code'
	claude update > /dev/null 2>&1
fi

# GitHub Copilot - https://github.com/features/copilot/cli

if [[ "$TARGET" == "all" || "$TARGET" == "copilot" ]] && [ ! "$(command -v copilot)" ]; then
  info 'Installing GitHub Copilot'
  curl -fsSL https://gh.io/copilot-install | bash > /dev/null 2>&1
elif [[ "$TARGET" == "all" || "$TARGET" == "copilot" ]]; then
	info 'Updating GitHub Copilot'
	copilot update > /dev/null 2>&1
fi
