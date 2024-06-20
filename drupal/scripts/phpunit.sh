#!/bin/bash

set -euo pipefail

export SIMPLETEST_BASE_URL="http://nginx"
# mysql://username:password@localhost/databasename#table_prefix
# if [ $DATABASE_CHOICE = 'postgres' ]; then
#   DB_PORT="5432"
#   DB_USER_PASS=$(cat $DB_USER_PASSWORD_FILE)
#   DB_CONN="pgsql://$DB_USER:$DB_USER_PASS@$DB_HOST/$DB_DATABASE_NAME"
# fi
# export SIMPLETEST_DB=$DB_CONN
# export SIMPLETEST_DB="sqlite://localhost/:memory:"

# # Works for FunctionalJavascript tests, run as root.
# export SIMPLETEST_DB="sqlite://var/www/html/$PROJECT_NAME/web/testDb/test.sqlite"

# Works for Functional tests, run as www-data.
export SIMPLETEST_DB="sqlite://./testDb/test.sqlite"

# export SIMPLETEST_DB="sqlite://var/www/html/$PROJECT_NAME/web/testDb/test.sqlite"
# /path/to/webroot/sites/simpletest/browser_output
mkdir -p "/var/www/html/$PROJECT_NAME/web/sites/simpletest/browser_output"
chown -R www-data:www-data "/var/www/html/$PROJECT_NAME/web/sites/simpletest"
chmod -R 777 "/var/www/html/$PROJECT_NAME/web/sites/simpletest"
export BROWSERTEST_OUTPUT_DIRECTORY="/var/www/html/$PROJECT_NAME/web/sites/simpletest/browser_output"
export BROWSERTEST_OUTPUT_DIRECTORY_BASE="/var/www/html/$PROJECT_NAME/web"

export MINK_DRIVER_ARGS_WEBDRIVER='["chrome", {"browserName":"chrome","chromeOptions":{"args":["--disable-gpu","--headless", "--no-sandbox", "--disable-dev-shm-usage"]}}, "http://chrome:9515"]'

export runFTest='sudo -u www-data /var/www/html/example/vendor/bin/phpunit --testdox -c /var/www/html/example/web/core /var/www/html/example/web/modules/mymod/tests/src/Functional/'
export runFJTest='/var/www/html/example/vendor/bin/phpunit --testdox -c /var/www/html/example/web/core /var/www/html/example/web/modules/mymod/tests/src/FunctionalJavascript/'

envsubst < /var/www/html/phpunit.xml.dist > /var/www/html/$PROJECT_NAME/phpunit.xml

rm /var/www/html/phpunit.xml.dist