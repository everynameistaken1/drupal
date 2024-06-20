# Drupal-base is pushed to everynameistaken1/drupal-base
# Image contains neccessary packages to successfully run drupal.
FROM php:8-fpm-alpine as drupal-base

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Needed for installation and configuration of libs.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
# Needed for installation of project.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add libmemcached envsubst sudo

# Needed for drupal.
# https://www.drupal.org/docs/getting-started/system-requirements/php-requirements
RUN install-php-extensions \
  gd \
  apcu \
  csv \
  opcache \
  pcntl \
  pdo_pgsql \
  pgsql \
  pdo_mysql \
  uploadprogress \
  memcached

# Needed configurations for php and php-fpm.
COPY ./ini/opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
COPY ./ini/error.ini /usr/local/etc/php/conf.d/error.ini
COPY ./ini/override.ini /usr/local/etc/php/conf.d/override.ini
COPY ./ini/mailhog.ini /usr/local/etc/php/conf.d/mailhog.ini
COPY ./ini/variables_order.ini /usr/local/etc/php/conf.d/variables_order.ini

# Show php-fpm status.
RUN sed 's/;pm.status_path.*/pm.status_path = \/status/' /usr/local/etc/php-fpm.d/www.conf > ./tmpFile && \
    cat ./tmpFile > /usr/local/etc/php-fpm.d/www.conf && \
    rm ./tmpFile

RUN sed 's/;ping.path/ping.path/' /usr/local/etc/php-fpm.d/www.conf > ./tmpFile && \
    cat ./tmpFile > /usr/local/etc/php-fpm.d/www.conf && \
    rm ./tmpFile

# -------------------------------------------------------

# Only-drupal is pushed to everynameistaken1/only-drupal
# Image adds scripts/packages to initialize a drupal instance and
# config settings for instance to properly run locally.
FROM drupal-base as only-drupal

WORKDIR /root/.config/drupal

# Scripts are part of entrypoint, look for start script in docker-compose.yml.
COPY ./scripts ./scripts
RUN chmod -R 770 ./scripts

# Bash aliases.
COPY ./.bashrc /root/.bashrc

# Helper scripts for user to create backup or set up solr/varnish/JsTests.
COPY ./backup.sh /var/www/html/backup.sh
COPY ./solr.sh /var/www/html/solr.sh
COPY ./varnish.sh /var/www/html/varnish.sh

RUN chmod 770 /var/www/html/backup.sh
RUN chmod 770 /var/www/html/solr.sh
RUN chmod 770 /var/www/html/varnish.sh

# Neccessary for setting up testing environment.
COPY ./phpunit.xml.dist /var/www/html/phpunit.xml.dist

# Sets up trusted host headers for local development.
COPY ./php/settings.txt .

# Neccessary for linter. Sets drupal coding standard and where to look.
COPY phpcs.xml .
COPY .gitignore .

# Neccessary for initializing database and cloning project.
RUN apk add postgresql-client mysql-client bash git jq

# -------------------------------------------------------

# Xdebug-base is pushed to everynameistaken1/xdebug-base
# Image adds debugger package, sets shared config values and
# exposes correct port.
FROM only-drupal as xdebug-base

RUN install-php-extensions xdebug-3.3.1

# Neccessary configurations for xdebug.
COPY ./ini/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Used by xdebug.
EXPOSE 9003

# -------------------------------------------------------

# Xdebug-vscode is pushed to everynameistaken1/xdebug-vscode
# Image adds correct setting for debugger so that vscode
# can communicate with it.
FROM xdebug-base as xdebug-vscode

# Neccessary configurations for vscode to be able to connect.
RUN echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# -------------------------------------------------------

# Xdebug-nvim is pushed to everynameistaken1/xdebug-nvim
# Image adds neccessary packages for neovim setup to function
# properly.
FROM xdebug-base as xdebug-nvim

# Neccessary for my neovim configuration to properly function.
RUN apk add neovim neovim-doc make gcc unzip wget gzip nodejs npm fd  \
    ripgrep curl python3 py3-pip py3-pynvim linux-headers \
    alpine-sdk build-base tree-sitter inotify-tools
RUN npm install -g neovim

WORKDIR /root/.config

RUN git clone --single-branch https://github.com/everynameistaken1/nvim.git nvim

# DAP used with neovim.
RUN git clone https://github.com/xdebug/vscode-php-debug.git vscode-php-debug && \
    cd vscode-php-debug && \
    npm install && npm run build

# Neccessary for LSP in neovim.
COPY .phpactor.json /root/.config/drupal

WORKDIR /var/www/html