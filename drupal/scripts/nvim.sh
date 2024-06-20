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


# For phpactor.
t=$(mktemp)
composer --working-dir="$PROJECT_PATH" config --no-plugins allow-plugins.fenetikm/autoload-drupal true
composer --working-dir="$PROJECT_PATH" require "fenetikm/autoload-drupal":"1.0.0"
jq '.extra += {"autoload-drupal": {"modules": ["web/modules/contrib/", "web/modules/custom/", "web/core/modules/"], "classmap": ["web/core/tests/Drupal/Tests", "web/core/tests/Drupal/FunctionalJavascriptTests", "web/modules/custom"]}}' "$PROJECT_PATH"/composer.json > $t
cat $t > "$PROJECT_PATH"/composer.json

# You will need to rerun the following command everytime
# you add or remove a module.
composer --working-dir="$PROJECT_PATH" dump-autoload
