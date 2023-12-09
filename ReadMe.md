# Drupal Development Environment #

This repository allows you to quickly set up an environment for working with drupal.

## Prerequisites ##

An understanding of:
1. Docker
2. Drupal
3. Git
4. Vscode/Neovim

## Installation ##

Create a new repository on github and create a token with the proper permissions. Clone this repository and make the appropriate changes to the [.env](https://github.com/everynameistaken1/drupal/blob/main/.env) file. Open your terminal and run the following command:

```
docker compose up -d
```

When all the containers have started, enter the drupal container. The "WORKDIR" is set to ***/root/.config/drupal***, here you will find two scripts. If the repository you created doesn't include a ***composer.json/lock***, you run the command:

```
. initialize-repository.sh
```

Otherwise run the command:

```
. existing-repository.sh
```

Once the script is done, you may visit localhost with the port you chose and see your website.

### Notice ###

When starting neovim the first time, let the plugin manager finish installing phpactor and then restart neovim. When using which-key drush commands, make sure you enter the editor from within root folder of ***/var/www/html/PROJECT_NAME*** like this
```
nvim /var/www/html/$PROJECT_NAME
```
Otherwise the path to drush binary won't be correct.

When using vscode, use command palette to attach to running drupal container. Then, open folder at ***/var/www/html/PROJECT_NAME***. Replace ***PROJECT_NAME*** with whatever value you set in ***.env*** file. Note that you will have to install whatever plugins you want/need inside vscode yourself.