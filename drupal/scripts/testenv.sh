#!/usr/bin/env bash

# Initializes your drupal project by cloning
# your repository, installs drupal and
# initializes database.

# Exit on errors.
set -euo pipefail



mkdir /var/www/html/$PROJECT_NAME/web/testDb
touch /var/www/html/$PROJECT_NAME/web/testDb/test.sqlite

chown -R www-data:www-data /var/www/html/$PROJECT_NAME/web/testDb
chmod -R 777 /var/www/html/$PROJECT_NAME/web/testDb

if [ 'true' = $FunctionalJavascript_ON ]; then
  t=$(mktemp)
  IGNORECASE=0
  awk -v CHROME_IP=$CHROME_IP_FRONTEND '{
    if ( $1 ~ /^127.0.0.1/ )
      { print CHROME_IP " localhost" }
    else
      { print }
  }' /etc/hosts > $t && cat $t > /etc/hosts
  echo "Set chrome service as localhost successfully."
  echo "FunctionalJavascript testing now available."
fi