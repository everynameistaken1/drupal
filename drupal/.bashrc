alias ll="ls -al"

alias drush="/var/www/html/$PROJECT_NAME/vendor/bin/drush"

alias cdp="cd /var/www/html/$PROJECT_NAME"
alias cdc="cd /var/www/html/$PROJECT_NAME/web/modules/custom"

alias testModulesUnit="sudo -u www-data /var/www/html/$PROJECT_NAME/vendor/bin/phpunit --testdox -c /var/www/html/$PROJECT_NAME --testsuite custom-modules-unit"
alias testModulesKernel="sudo -u www-data /var/www/html/$PROJECT_NAME/vendor/bin/phpunit --testdox -c /var/www/html/$PROJECT_NAME --testsuite custom-modules-kernel"
alias testModulesFunc="sudo -u www-data /var/www/html/$PROJECT_NAME/vendor/bin/phpunit --testdox -c /var/www/html/$PROJECT_NAME --testsuite custom-modules-func"
alias testModulesJs="/var/www/html/$PROJECT_NAME/vendor/bin/phpunit --testdox -c /var/www/html/$PROJECT_NAME --testsuite custom-modules-js"
alias testModulesAll="sudo -u www-data /var/www/html/$PROJECT_NAME/vendor/bin/phpunit --testdox -c /var/www/html/$PROJECT_NAME --testsuite custom-modules-all-but-js && testModulesJs"

alias backupSite="/var/www/html/backup.sh"
alias backupTestPrints="cp /var/www/html/$PROJECT_NAME/web/sites/simpletest/browser_output/* /root/.config/drupal/FunctionalTests"