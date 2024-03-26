#!/usr/bin/env bash

# Nvim relevant files copied over to project.

# Exit on errors.
set -euo pipefail

# Path to potential phpcs file.
if [ ! -f "$PHPCS" ]; then
  # If none exist, copy over.
  echo "Copying over phpcs.xml, please wait..."
  cp $drupConfPath/phpcs.xml $PROJECT_PATH/phpcs.xml
fi

# Path to potential phpactor file.
if [ ! -f "$PHPA" ]; then
  # If none exist, copy over.
  echo "Copying over .phpactor.json, please wait..."
  cp $drupConfPath/.phpactor.json $PROJECT_PATH/.phpactor.json
fi
