#!/usr/bin/env bash

# Initializes mysql database.

# Exit on errors.
set -euo pipefail

# If database is not initialized, we use drush to initialize
# site with values submitted through env file.
echo "Setting variable names, please wait..."
DB_PORT=3306
DB_USER_PASS=$(cat $DB_USER_PASSWORD_FILE)
ACCOUNT_PASS=$(cat /run/secrets/account_pass)
SITE_PASS=$(cat /run/secrets/site_pass)

# Error if value doesn't exists.
echo "Checking database user password, please wait..."
if [ -z "$DB_USER_PASS" ]; then echo "DB_USER_PASSWORD_FILE can't be empty or unset" && exit 1; fi

# Attempt connecting to database to see if it's ready.
echo "Checking if database is running, please wait..."
for i in $(seq 1 30); do
  echo "Attempt $i of 30"
  connected=$(mysql -u$DB_USER -p$DB_USER_PASS -h$DB_HOST -e "exit" >/dev/null 2>&1 || echo "false")
  if [ $connected = "false" ]; then
    if [ $i -eq 30 ]; then
      echo "Failed to connect within 30 tries, please reinstall or report issue."
      exit 1
    fi
    sleep 5
  else
    break
  fi
done

echo "Checking if database is initialized, please wait..."
if [ $(mysql -u$DB_USER -p$DB_USER_PASS -h$DB_HOST -D$DB_DATABASE_NAME --disable-column-names -e "SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_name = '$TABLE_EXISTS' ) AS table_existence;") = "0" ]; then
  echo "Initializing database for drupal site...";
  export PATH="$PROJECT_PATH/vendor/bin:$PATH"
  if [ -e "$PROJECT_NAME/config/system.site.yml" ]; then
    drush si --yes \
      --db-url=mysql://$DB_USER:$DB_USER_PASS@$DB_HOST:$DB_PORT/$DB_DATABASE_NAME \
      --account-name=$ACCOUNT_NAME \
      --account-mail=$ACCOUNT_MAIL \
      --site-mail=$SITE_MAIL \
      --account-pass=$ACCOUNT_PASS \
      --site-name=$SITE_NAME \
      --site-pass=$SITE_PASS;

    # Gets UUID from configuration backup.
    configUuid=$(cat $PROJECT_PATH/config/system.site.yml | grep uuid | awk '{print $2}') || echo "ERROR: Couldn't get UUID."
    # Sets UUID for new site and imports all configurations.
    echo "Importing fullsite configurations, please wait..."
    drush cset system.site uuid "$configUuid" -y && drush entity:delete shortcut_set && drush cim -y || echo "ERROR: Couldn't import configuration."
    echo "Running cron, please wait..."
    drush cron -v || echo "ERROR: Couldn't run cron."
  elif [ $(ls "$PROJECT_PATH/config" | grep .yml -c) -gt 0 ]; then
    drush si --yes \
      --db-url=mysql://$DB_USER:$DB_USER_PASS@$DB_HOST:$DB_PORT/$DB_DATABASE_NAME \
      --account-name=$ACCOUNT_NAME \
      --account-mail=$ACCOUNT_MAIL \
      --site-mail=$SITE_MAIL \
      --account-pass=$ACCOUNT_PASS \
      --site-name=$SITE_NAME \
      --site-pass=$SITE_PASS;

    # Remove UUID field.
    for configFile in $PROJECT_PATH/config/*; do
      t=$(mktemp)
      IGNORECASE=0
      awk '{
      if ( $1 ~ /uuid:/ )
        { next }
      else
        { print }
      }' $configFile > "$t" && mv "$t" $configFile
    done
    echo "Importing partial configurations, please wait..."
    drush cim --partial -y || echo "ERROR: Couldn't import partial configuration."
    echo "Running cron, please wait..."
    drush cron -v || echo "ERROR: Couldn't run cron."
  else
    drush si --yes \
      --db-url=mysql://$DB_USER:$DB_USER_PASS@$DB_HOST:$DB_PORT/$DB_DATABASE_NAME \
      --account-name=$ACCOUNT_NAME \
      --account-mail=$ACCOUNT_MAIL \
      --site-mail=$SITE_MAIL \
      --account-pass=$ACCOUNT_PASS \
      --site-name=$SITE_NAME \
      --site-pass=$SITE_PASS;
    echo "Running cron, please wait..."
    drush cron -v || echo "ERROR: Couldn't run cron."
  fi
  echo "Successfully installed site!"
else
  echo "Site already initialized!";
fi
