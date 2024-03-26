#!/usr/bin/env bash

# If backups exist, copy over to project path.

# Exit on errors.
set -euo pipefail

# If backup files exists, add to project path.
echo "Checking if files backup exists..."
if [ -d $FILESFOLDER ]; then
  echo "Files backup found."
  if [ -d "$PROJECT_PATH/web/sites/default/files" ]; then
    echo "Checking if files folder exits..."
    rm -rf $PROJECT_PATH/web/sites/default/files
  fi
  mkdir -p $PROJECT_PATH/web/sites/default
  echo "Copying files backup to project, please wait..."
  cp -r $FILESFOLDER $PROJECT_PATH/web/sites/default/files
fi

# If backup settings exists, add to project path.
echo "Checking if settings file backup exists..."
if [ -e $SETTINGSFILES ]; then
  echo "Settings file backup found."
  if [ -e "$PROJECT_PATH/web/sites/default/settings.php" ]; then
    rm -f $PROJECT_PATH/web/sites/default/settings.php
  fi
  mkdir -p $PROJECT_PATH/web/sites/default
  echo "Copying settings file backup to project, please wait..."
  cp $SETTINGSFILES $PROJECT_PATH/web/sites/default/settings.php
fi

# If backup configurations exists, add to project path.
echo "Checking if config backup exists..."
if [ -d $CONFIGFOLDER ]; then
  echo "Config backup found."
  if [ -d "$PROJECT_PATH/config" ]; then
    rm -rf $PROJECT_PATH/config
  fi
  echo "Copying config backup to project, please wait..."
  cp -r $CONFIGFOLDER $PROJECT_PATH/config
fi
