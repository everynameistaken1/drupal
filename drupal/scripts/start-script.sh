#!/usr/bin/env bash

# Initializes your drupal project by cloning
# your repository, installs drupal and
# initializes database.

# Exit on errors.
set -euo pipefail

# Validate environment variables
. /root/.config/drupal/scripts/check-env.sh

# Configure git.
. /root/.config/drupal/scripts/git.sh

# Paths as environment variables to to make script more readable.
# Where drupal gitignore, phpcs and potential
# backup exists.
drupConfPath=/root/.config/drupal

# Path to potential folders and files.
PROJECT_PATH="/var/www/html/$PROJECT_NAME"
FILESFOLDER="$drupConfPath/initDrupal/default/files"
SETTINGSFILES="$drupConfPath/initDrupal/default/settings.php"
CONFIGFOLDER="$drupConfPath/initDrupal/config"
composerJson=$PROJECT_PATH/composer.json
composerLock=$PROJECT_PATH/composer.lock
PHPCS=$PROJECT_PATH/phpcs.xml
PHPA=$PROJECT_PATH/.phpactor.json

# If folder exists, initialization has already
# happened.
if [ -d "$PROJECT_PATH" ]; then

  # If backup exists, copy over to project.
  . /root/.config/drupal/scripts/backup-exists.sh

  # Restrict permissions for relevant folders and files.
  . /root/.config/drupal/scripts/restrict-perm.sh

  # Start php-fpm
  php-fpm
fi

# Clones your repository.
git clone $CLONE_FLAGS $CLONE_REPOSITORY $PROJECT_PATH

# Installs from existing composer config or creates new project.
. /root/.config/drupal/scripts/composer.sh

# Creates relevant files and folders neccessary for drupal site.
. /root/.config/drupal/scripts/init-default.sh

# If backup exists, copy over to project.
. /root/.config/drupal/scripts/backup-exists.sh

# Copy over neccessary nvim files.
. /root/.config/drupal/scripts/nvim.sh

# Initialize database, checks for which type of database
# you choose and runs proper commands.
if [ $DATABASE_CHOICE = "postgres" ]; then
  . /root/.config/drupal/scripts/postgres.sh
elif [ $DATABASE_CHOICE = "mysql" ]; then
  . /root/.config/drupal/scripts/mysql.sh
else
  echo "$DATABASE_CHOICE not supported."
  exit 1
fi

# So testing runs on separate Db.
. /root/.config/drupal/scripts/wrapDbSettings.sh

# Prepares testing environment.
. /root/.config/drupal/scripts/testenv.sh
. /root/.config/drupal/scripts/phpunit.sh

# Restrict permissions for relevant folders and files.
. /root/.config/drupal/scripts/restrict-perm.sh

# Start php-fpm
php-fpm
