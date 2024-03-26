# Drupal Development Environment #

This repository allows you to quickly set up an environment for working with drupal.

---

## Prerequisites ##

An understanding of:
- Docker
- Drupal
- Git
- Vscode/Neovim

---

## Installation ##

Create a new repository on github and create a token with the proper permissions. Clone [this](https://github.com/everynameistaken1/drupal) repository and make the appropriate changes to the [.env](https://github.com/everynameistaken1/drupal/blob/main/.env) file. Open the folder in your terminal and run the following command:

```
docker compose up -d && docker compose attach drupal
```

You may begin working when you see:

> NOTICE: ready to handle connections

### Warning ###

Sometimes the ***docker compose up -d*** command fails to set up networking properly. Use ***docker network inspect NETWORK_NAME*** to make sure it has the containers specified in the [docker-compose.yml](https://github.com/everynameistaken1/drupal/blob/main/docker-compose.yml) file connected to it. If a container is not connected, use ***docker network connect NETWORK_NAME CONTAINER_NAME*** command or remove the containers/volumes and redo everything.

---

### Backups ###

I have included a simple script called ***backup.sh*** inside the drupal container, at path ***/var/www/html/backup.sh***. You may use this script to create a backup of your ***settings.php*** file, ***config*** folder, ***files*** folder and database. Your backup will be saved to your host machine inside the ***./drupal/backup*** folder, as shown inside the ***docker-compose.yml*** file. To start from a backup, copy over ***./drupal/backup/<BACKUP_DATETIME>/default*** and ***./drupal/backup/<BACKUP_DATETIME>/config*** into ***./drupal/initDrupal***. Then copy over ***./drupal/backup/<BACKUP_DATETIME>/sqlBackup/sqlBackup.sql*** into ***./db/initdb/sqlBackup.sql***

The result should look like this:

> ./drupal/initDrupal/config

> ./drupal/initDrupal/default/files

> ./drupal/initDrupal/default/settings.php

> ./db/initdb/sqlBackup.sql

You can use the following commands to quickly copy over your backup. Don't forget to change <BACKUP_DATETIME> first.

```
rm -rf ./drupal/initDrupal/* && rm -f ./db/initdb/* && cp -rf ./drupal/backup/<BACKUP_DATETIME>/config ./drupal/backup/<BACKUP_DATETIME>/default ./drupal/initDrupal && cp -f ./drupal/backup/<BACKUP_DATETIME>/sqlBackup/backup.sql ./db/initdb/backup.sql
```

---

### Notice ###

When starting neovim the first time, let the plugin manager finish installing phpactor and then restart neovim, You may have to press enter at some point during the plugin managers installation process because of a message.

When using vscode, use command palette to attach to running drupal container. Then, open folder at ***/var/www/html/PROJECT_NAME***. Replace ***PROJECT_NAME*** with whatever value you set in ***.env*** file. Note that you will have to install whatever plugins you want/need inside vscode yourself.