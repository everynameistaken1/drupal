#!/usr/bin/env bash

# Initializes postgres database.

# Exit on errors.
set -euo pipefail

# Set relevant variables.
echo "Setting variable names, please wait..."
DB_PORT="5432"
DB_USER_PASS=$(cat $DB_USER_PASSWORD_FILE)
ACCOUNT_PASS=$(cat /run/secrets/account_pass)
SITE_PASS=$(cat /run/secrets/site_pass)
# Needs to be exported for psql command to work.
export PGPASSWORD=$DB_USER_PASS

# Error if value doesn't exists.
echo "Checking database user password, please wait..."
if [ -z "$DB_USER_PASS" ]; then echo "DB_USER_PASSWORD_FILE can't be empty or unset" && exit 1; fi

echo "Checking if table <$TABLE_EXISTS> exists...";

# Connect to database to see if it's ready.
echo "Checking if database is running, please wait..."
for i in $(seq 1 30); do
  echo "Attempt $i of 30"
  connected=$(psql -h $DB_HOST -U $DB_USER -d $DB_DATABASE_NAME -c "\q" >/dev/null 2>&1 || echo "false")
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

# Checks if database is already initialized.
echo "Checking if database is initialized, please wait..."
if [ $(psql -At -h $DB_HOST -U $DB_USER -d $DB_DATABASE_NAME -c "SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_name = '$TABLE_EXISTS' ) AS table_existence;") = "t" ]
  then
    echo "Site already initialized!";
  else
    # If database is not initialized, we use drush to initialize
    # site with values submitted through env file.
    echo "Initializing database for drupal site...";
    export PATH="$PROJECT_PATH/vendor/bin:$PATH"
    if [ -e "$PROJECT_NAME/config/system.site.yml" ]; then
      drush si --yes \
        --db-url=pgsql://$DB_USER:$DB_USER_PASS@$DB_HOST:$DB_PORT/$DB_DATABASE_NAME \
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
        --db-url=pgsql://$DB_USER:$DB_USER_PASS@$DB_HOST:$DB_PORT/$DB_DATABASE_NAME \
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
        --db-url=pgsql://$DB_USER:$DB_USER_PASS@$DB_HOST:$DB_PORT/$DB_DATABASE_NAME \
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
fi
