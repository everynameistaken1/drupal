# Drupal Development Environment

This repository allows you to "quickly" set up an environment for working with drupal.

---

## Prerequisites

An understanding of:
- Docker
- Drupal
- Git
- Neovim/Vscode

---

## Installation

Create a new repository for your new drupal project, if you don't already have one, on github and create a token with the proper permissions.

Clone [this](https://github.com/everynameistaken1/drupal) repository and make the appropriate changes to this [env](https://github.com/everynameistaken1/drupal/blob/main/.env) file and [these](https://github.com/everynameistaken1/drupal/tree/main/env) env files. You are not to make changes to the env files inside the [NotToBeChanged](https://github.com/everynameistaken1/drupal/tree/main/env/NotToBeChanged) folder.

```bash
git clone --depth 1 --branch 1.0.0 https://github.com/everynameistaken1/drupal.git PATH
```

Run the following command in the root of the cloned [folder](https://github.com/everynameistaken1/drupal):

```bash
mv ./secrets/example-account-pass.txt ./secrets/account-pass.txt && \
mv ./secrets/example-db-root-pass.txt ./secrets/db-root-pass.txt && \
mv ./secrets/example-db-user-pass.txt ./secrets/db-user-pass.txt && \
mv ./secrets/example-git-pass.txt ./secrets/git-pass.txt && \
mv ./secrets/example-site-pass.txt ./secrets/site-pass.txt
```

Then make the relevant changes for your projects secrets.

Now you're ready to start by entering the following command.

```bash
docker compose up -d && docker compose attach drupal
```

You may begin working when you see:

> NOTICE: ready to handle connections

---

## Backups

I have included a bash alias named ***backupSite*** that can be used inside the drupal container, this runs the script ***/var/www/html/backup.sh***. You may use this alias to create a backup of your ***settings.php*** file, ***config*** folder, ***files*** folder and database. Your backup will be saved to your host machine inside the ***./drupal/backup*** folder, as shown inside the ***docker-compose.yml*** file. To start from a backup, copy over ***./drupal/backup/<BACKUP_DATETIME>/default*** and ***./drupal/backup/<BACKUP_DATETIME>/config*** into ***./drupal/initDrupal***. Then copy over ***./drupal/backup/<BACKUP_DATETIME>/sqlBackup/sqlBackup.sql*** into ***./db/initdb/sqlBackup.sql***

The result, of you copying over your backup, should look like this:

> ./drupal/initDrupal/config

> ./drupal/initDrupal/default/files

> ./drupal/initDrupal/default/settings.php

> ./db/initdb/sqlBackup.sql

You can use the following commands to quickly copy over your backup. Don't forget to change <BACKUP_DATETIME> first.

```bash
rm -rf ./drupal/initDrupal/* && rm -f ./db/initdb/* && cp -rf ./drupal/backup/<BACKUP_DATETIME>/config ./drupal/backup/<BACKUP_DATETIME>/default ./drupal/initDrupal && cp -f ./drupal/backup/<BACKUP_DATETIME>/sqlBackup/backup.sql ./db/initdb/backup.sql
```

---

## Testing

With the exception of Nightwatch tests, testing works out of the box. I have included aliases for running different types of tests inside [.bashrc](https://github.com/everynameistaken1/drupal/blob/main/drupal/.bashrc). Note that we use a different user for FunctionalJavascript tests, this is required. If you want to run FunctionalJavascript tests, you will have to uncomment the ***chrome*** service inside [docker-compose.yml](https://github.com/everynameistaken1/drupal/blob/main/docker-compose.yml) and change [FunctionalJavascript_On](https://github.com/everynameistaken1/drupal/blob/main/env/testing.env) to ***true***. If you want to save print outs from tests to host, use alias ***backupTestPrints*** inside drupal container.

---

## Memcached

Uncomment ***memcached*** service in [docker-compose.yml](https://github.com/everynameistaken1/drupal/blob/main/docker-compose.yml). You may also change the memory allotted to service, default is 64 Mb.

You can test connecting to ***memcached*** by entering the drupal container and running the following commands.

Below we set the ***foo*** key and ***bar*** value.

```bash
echo -ne "set foo 0 500 3\r\nbar\r\n" | nc memcached 11211
```

Below we get the value at key ***foo***.

```bash
echo -ne "get foo\r\n" | nc memcached 11211
```

---

## Solr

To set up Solr (Core version), follow these steps:

1. Uncomment the Solr service inside the [docker-compose.yml](https://github.com/everynameistaken1/drupal/blob/main/docker-compose.yml), follow the instructions for ***Installation*** above.
2. Enter the drupal container and run the ***/var/www/html/solr.sh*** script.
3. Visit your website and navigate to ***[Search API](http://localhost/admin/config/search/search-api)*** and click ***Add server***.
4. Fill in the ***Server name*** field, choose ***Standard*** for Solr connector, change ***solr host*** to ***solr*** and enter ***drupal*** into ***Solr core***. ***Solr core*** is named ***drupal*** because of the volume mapping in [docker-compose.yml](https://github.com/everynameistaken1/drupal/blob/main/docker-compose.yml), if you want a different name, make the appropriate changes.
5. After saving, click the ***Get config.zip*** button. Copy over the files that got downloaded into a folder named ***solr*** inside the root of the [project](https://github.com/everynameistaken1/drupal/), e.g. ***./solr/example.xml***.
6. Move the ***./solr/elevate.xml*** into ***./solr/data/elevate.xml***, create the ***./solr/data*** folder first.
7. Open a new tab in your browser and navigate to Solr. If no changes were made to default ports, location should be at [localhost:8983](http://localhost:8983).
8. Navigate to ***Core Admin***, enter ***drupal*** into ***name:*** field, enter ***drupal*** into ***instanceDir:*** field and click ***Add Core***.
9. You are now done and may return to ***[Search API](http://localhost/admin/config/search/search-api)*** to set up your indexes.

---

## Varnish

To set up Varnish, follow these steps:

1. Uncomment the Varnish service inside the [docker-compose.yml](https://github.com/everynameistaken1/drupal/blob/main/docker-compose.yml), follow the instructions for ***Installation*** above.
2. Enter the drupal container and run the ***/var/www/html/varnish.sh*** script.
3. Visit your website and navigate to ***[Perfomance](http://localhost/admin/config/development/performance)***.
4. Set the ***Browser and proxy cache maximum age*** to ***1 year***. Then save the changes.
5. Navigate to ***[Purge](http://localhost/admin/config/development/performance/purge)***.
6. Click the ***Add purger***.
7. Choose ***HTTP PURGER*** and click ***Add***.
8. Inside ***Cache Invalidation*** click the down arrow next to ***HTTP Purger (Unique Hash)***. Then click ***Configure***.
9. Fill in the ***name*** field with whatever name you want, e.g. ***Varnish***.
10. Change ***Hostname*** field from ***localhost*** to ***solr***. Leave the rest of the fields to default values.
11. Click ***Headers***.
12. In ***Header*** field enter ***Purge-Cache-Tags***. In ***Value*** field enter ***[invalidation:expression]***, including the brackets.
13. Click ***Save configuration***. You are now done.

---

## Note

When starting neovim the first time, let the plugin manager finish installing phpactor and then restart neovim, You may have to press enter at some point during the plugin managers installation process because of a message. Phpactor works fine inside psr-4 autoloaded files but struggles with classmap autoloaded files, will sometimes require you to exit out of nvim, removing ***~/.cache/phpactor***, and back in to work. Also note that you will have to rerun the following command everytime you add or remove a module:

```bash
composer --working-dir="/var/www/html/$PROJECT_NAME" dump-autoload
```

When using vscode, use command palette to attach to running drupal container. Then, open folder at ***/var/www/html/PROJECT_NAME***. Replace ***PROJECT_NAME*** with whatever value you set in ***.env*** file. Note that you will have to install whatever plugins you want/need inside vscode yourself.

Added ***apache2-utils*** and ***parallel*** to ***Nginx*** so that you can run performance tests on your site. Enter your nginx container with ***/bin/bash*** and run below command as an example.

```bash
mkdir -p Results && parallel --jobs 4 ab -n 2000 -c 4 -e :::: "./perf/filenames.txt" ::::+ "./perf/urls.txt" >> Results/Result.txt 2>&1
```

Set up /status and /ping for php-fpm so you can see usage statistics.
