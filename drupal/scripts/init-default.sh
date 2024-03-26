#!/usr/bin/env bash

# Initializes default folders and files.

# Exit on errors.
set -euo pipefail

# Ensures these folders exist.
echo "Making sure files and config folder exists, please wait..."
mkdir -p $PROJECT_PATH/web/sites/default/files
mkdir -p $PROJECT_PATH/config

echo "Creating settings file, please wait..."
cp $PROJECT_PATH/web/sites/default/default.settings.php $PROJECT_PATH/web/sites/default/settings.php
# Adds trusted host settings, for localhost development.
echo "Adding settings from settings.txt to settings file, please wait..."
cat $drupConfPath/settings.txt >> $PROJECT_PATH/web/sites/default/settings.php
# Tells drupal to use config folder outside web folder in project path.
echo "Adding config path to settings file, please wait..."
echo "\$settings['config_sync_directory'] = '$PROJECT_PATH/config';" >> $PROJECT_PATH/web/sites/default/settings.php
