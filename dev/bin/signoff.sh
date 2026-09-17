#!/usr/bin/env bash
#
#
# Dev signoff tool for GitHub repositories
#   - CI processing can be slow, so if a local dev machine can run tests, this tool can facilitate that and then sign the commit
# 	- GitHub will then natively display the status on the commit on relevant detail and list pages
#   - Requires the GitHub CLI: https://cli.github.com/
#   - Requires authentication via the GitHub CLI: https://cli.github.com/manual/gh_auth_login
#     - gh auth login --clipboard --web --skip-ssh-key --scopes repo,read:user,read:packages
#   - Related GitHub API docs: https://docs.github.com/en/rest/commits/statuses?apiVersion=2026-03-10#create-a-commit-status
#   - Inspired by:
#     - https://github.com/basecamp/gh-signoff
#     - https://gist.github.com/dhh/c5051aae633ff91bc4ce30528e4f0b60
#
#

# Abort sign off on any error
set -e

# Start the benchmark timer
SECONDS=0

# Repository introspection
OWNER=$(gh repo view --json owner --jq .owner.login)
REPO=$(gh repo view --json name --jq .name)
SHA=$(git rev-parse HEAD)
SHA_SHORT=$(git rev-parse --short HEAD)
USER_NAME=$(git config user.name)
USER_EMAIL=$(git config user.email)

# Progress reporting
GREEN=32; RED=31; BLUE=34
announce() { echo -e "\033[0;$2m$1\033[0m"; }
run() {
  local SPLIT=$SECONDS
  announce "\nRun $1" $BLUE
  eval "$1"
  local INTERVAL=$((SECONDS-SPLIT))
  announce "Completed $1 in $INTERVAL seconds" $GREEN
}

# Sign off requires a clean repository
if [[ -n $(git status --porcelain) ]]; then
  announce "Can't sign off on a dirty repository!" $RED
  git status
  exit 1
else
  announce "Attempting to sign off on $SHA_SHORT in $OWNER/$REPO as $USER_NAME <$USER_EMAIL>" $GREEN
fi

# Required step(s) for sign off
#   - This could include unit test commands, linting, etc
#   - Use the "run" function so the output is consistent and the "$SECONDS" counter is updated.

run "sleep 3"

# Report successful sign off to GitHub

gh api \
  --method POST --silent \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  /repos/$OWNER/$REPO/statuses/$SHA \
  -f "context=signoff" \
  -f "state=success" \
  -f "description=Signed off by $USER_NAME <$USER_EMAIL> ($SECONDS seconds)"

announce "Signed off on $SHA_SHORT in $SECONDS seconds" $GREEN
