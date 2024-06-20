#!/usr/bin/env bash

# Restricts permissions for relevant folders and files.

# Exit on errors.
set -euo pipefail

# Restrict privileges for important folders and files.
echo "Changing permissions, please wait..."
chown -R www-data:www-data $PROJECT_PATH/config
chown -R www-data:www-data $PROJECT_PATH/web/sites
chmod -R 770 $PROJECT_PATH/config
chmod -R 770 $PROJECT_PATH/web/sites/default
chmod 770 $PROJECT_PATH/web/sites/default/settings.php

# Testing db.
chown -R www-data:www-data /var/www/html/$PROJECT_NAME/web/testDb
chmod -R 777 /var/www/html/$PROJECT_NAME/web/testDb
