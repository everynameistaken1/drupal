#!/usr/bin/env bash

# Installs and enables purge, purge_purger_http and submodules.

# Exit on error.
set -euo pipefail

composer require --working-dir=/var/www/html/"$PROJECT_NAME" drupal/purge:^3 drupal/purge_purger_http:^1

/var/www/html/"$PROJECT_NAME"/vendor/bin/drush en purge_drush \
  purge_processor_lateruntime \
  purge_queuer_coretags \
  purge_processor_cron \
  purge_tokens \
  purge_ui \
  purge \
  purge_purger_http \
  purge_purger_http_tagsheader -y
