#!/usr/bin/env bash

# Configures git user.

# Exit on errors.
set -euo pipefail

# Create git credentials file and input
# your credentials.
echo "Creating git config folder, please wait..."
mkdir -p /root/.config/git
touch /root/.config/git/.creds
echo https://$GIT_USERNAME:$(cat /run/secrets/git_pass)@github.com >> /root/.config/git/.creds
git config --global credential.helper "store --file /root/.config/git/.creds"
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USERNAME
