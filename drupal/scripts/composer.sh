#!/usr/bin/env bash

# Installs all dependencies using composer.

# Exit on errors.
set -euo pipefail

# If files exists, install dependencies.
# Otherwise, create new project.
echo "Creating your project, please wait..."
if [ -e "$composerJson" ]; then
  echo "Installing your project, please wait..."
  composer install --working-dir="$PROJECT_PATH" --no-interaction
  echo "Installing your production/development dependencies, please wait..."
  composer require --working-dir="$PROJECT_PATH" $THIRD_PARTY_MODULES_PROD --no-interaction && composer require --working-dir="$PROJECT_PATH" $THIRD_PARTY_MODULES_DEV --no-interaction --dev
elif [ -e "$composerLock" ]; then
  echo "Installing your project, please wait..."
  composer install --working-dir="$PROJECT_PATH" --no-interaction
  echo "Installing your production/development dependencies, please wait..."
  composer require --working-dir="$PROJECT_PATH" $THIRD_PARTY_MODULES_PROD --no-interaction && composer require --working-dir="$PROJECT_PATH" $THIRD_PARTY_MODULES_DEV --no-interaction --dev
else
  # Create project.
  echo "Creating your project, please wait..."
  composer create-project $COMPOSER_CREATE_REPOSITORY $PROJECT_PATH/tmpDrupalSite --no-interaction
  mv -f $PROJECT_PATH/tmpDrupalSite/* $PROJECT_PATH && mv -f $PROJECT_PATH/tmpDrupalSite/.e* $PROJECT_PATH && mv -f $PROJECT_PATH/tmpDrupalSite/.g* $PROJECT_PATH
  rm -rf $PROJECT_PATH/tmpDrupalSite
  cp $drupConfPath/.gitignore $PROJECT_PATH/.gitignore

  # Require dependencies set by you.
  echo "Installing your production/development dependencies, please wait..."
  composer require --working-dir="$PROJECT_PATH" $THIRD_PARTY_MODULES_PROD --no-interaction && composer require --working-dir="$PROJECT_PATH" $THIRD_PARTY_MODULES_DEV --no-interaction --dev

  mkdir -p "$PROJECT_PATH/web/modules/custom"
fi


# Dependency for initializing database.
if [ ! -e "$PROJECT_PATH/vendor/bin/drush" ]; then
  echo "Installing drush, please wait..."
  composer require --working-dir="$PROJECT_PATH" "drush/drush" --no-interaction --dev
fi

composer require --working-dir="$PROJECT_PATH" "drupal/core-dev:^10" --no-interaction --dev --update-with-all-dependencies
