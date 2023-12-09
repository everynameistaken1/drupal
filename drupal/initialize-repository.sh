#!/bin/bash

set -eux

# Clone repository
cd /var/www/html
mkdir /root/.config/git
touch /root/.config/git/.creds
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USERNAME
echo https://$GIT_USERNAME:$(cat /run/secrets/git_pass)@github.com >> /root/.config/git/.creds
git config --global credential.helper "store --file /root/.config/git/.creds"
git clone $CLONE_FLAGS https://$CLONE_REPOSITORY $PROJECT_NAME
cd $PROJECT_NAME
composer create-project drupal/recommended-project drupal-site --no-interaction
cp -r drupal-site/* .
rm -rf drupal-site
cp /root/.config/drupal/.gitignore .
composer require $THIRD_PARTY_MODULES_PROD --no-interaction && composer require $THIRD_PARTY_MODULES_DEV --no-interaction --dev
mkdir ./web/sites/default/files
cp ./web/sites/default/default.settings.php ./web/sites/default/settings.php
mkdir -p ./config
chgrp -R www-data ./config
chgrp -R www-data ./web/sites
chmod -R 770 ./web/sites/default
chmod 770 ./web/sites/default/settings.php
cat /root/.config/drupal/settings.txt >> ./web/sites/default/settings.php
echo "\$settings['config_sync_directory'] = '/var/www/html/$PROJECT_NAME/config';" >> ./web/sites/default/settings.php

# Initialize database.
echo "Checking if table <$TABLE_EXISTS> exists...";

POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)

ACCOUNT_PASS=$(cat /run/secrets/account_pass)
SITE_PASS=$(cat /run/secrets/site_pass)

if [ $(psql -At -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -password $POSTGRES_PASSWORD -c "SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_name = '$TABLE_EXISTS' ) AS table_existence;") = "t" ]
  then
    echo "Site already initialized!";
  else
    echo "Initializing database for drupal site...";
    curPath=$(pwd);
    cd /var/www/html/$PROJECT_NAME;
    export PATH="./vendor/bin:$PATH"
    drush si --yes \
      --db-url=pgsql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB \
      --account-name=$ACCOUNT_NAME \
      --account-mail=$ACCOUNT_MAIL \
      --site-mail=$SITE_MAIL \
      --account-pass=$ACCOUNT_PASS \
      --site-name=$SITE_NAME \
      --site-pass=$SITE_PASS;
    cd $curPath;
    echo "Successfully installed site!"
fi