#!/usr/bin/env bash

# Installs and enables solr_api_search.

# Exit on error.
set -euo pipefail

composer require --working-dir=/var/www/html/"$PROJECT_NAME" drupal/search_api_solr:^4

/var/www/html/"$PROJECT_NAME"/vendor/bin/drush en search_api_solr -y
/var/www/html/"$PROJECT_NAME"/vendor/bin/drush un search -y