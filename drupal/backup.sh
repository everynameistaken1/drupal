#!/bin/bash

# Creates a backup of database, files,
# settings and configuration.

# Exits on error.
set -euo pipefail

# Path to your project.
projPath=/var/www/html/$PROJECT_NAME

# Date and time when creating backup,
# is used as folder name for backup.
curDateTime=$(date +"%Y-%m-%d_%H-%M-%S")

# Create neccessary folders for backup.
mkdir -p /root/.config/drupal/backup/$curDateTime/sqlBackup
mkdir -p /root/.config/drupal/backup/$curDateTime/default/files
mkdir -p /root/.config/drupal/backup/$curDateTime/config

# Path to new backup.
backupPath=/root/.config/drupal/backup/$curDateTime

# Creates database backup, mysql requires
# additional flag to avoid a privilege error.
echo "Creating backup of database, please wait..."
if [ $DATABASE_CHOICE = "mysql" ]; then
  $projPath/vendor/bin/drush sql-dump --extra-dump=--no-tablespaces --create-db --result-file=$backupPath/sqlBackup/backup.sql
else
  $projPath/vendor/bin/drush sql:dump --create-db --result-file=$backupPath/sqlBackup/backup.sql
fi

# Creates files backup.
echo "Creating backup of files, please wait..."
cp -r $projPath/web/sites/default/files $backupPath/default

# Creates settings backup.
echo "Creating backup of settings, please wait..."
cp $projPath/web/sites/default/settings.php $backupPath/default/settings.php

# Creates configurations backup.
echo "Exporting configurations, please wait..."
$projPath/vendor/bin/drush cex -y
echo "Creating backup of configurations, please wait..."
cp -r $projPath/config $backupPath

echo "--- WARNING ---"
echo "Don't forget to push this version of your codebase to"
echo "your remote version control system."