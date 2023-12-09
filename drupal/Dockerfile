FROM everynameistaken1/only-drupal:0.1.0 as only-drupal

FROM everynameistaken1/xdebug-vscode:0.1.0 as xdebug-vscode

FROM everynameistaken1/xdebug-nvim:0.1.0 as xdebug-nvim

# # drupal-base is pushed to everynameistaken1/drupal-base
# # Image contains neccessary packages to successfully run drupal.
# FROM php:8.2-fpm-alpine3.18 as drupal-base

# RUN apk update

# COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
# COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# RUN install-php-extensions \
#   gd \
#   apcu \
#   csv \
#   opcache \
#   pcntl \
#   pdo_pgsql \
#   pgsql \
#   uploadprogress

# COPY ./ini/opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
# COPY ./ini/error.ini /usr/local/etc/php/conf.d/error.ini
# COPY ./ini/override.ini /usr/local/etc/php/conf.d/override.ini

# RUN chown -R 644 /usr/local/etc/php/conf.d

# # -------------------------------------------------------

# # only-drupal is pushed to everynameistaken1/only-drupal
# # Image adds scripts/packages to initialize a drupal instance and
# # config settings for instance to properly run locally.
# FROM drupal-base as only-drupal
# # FROM everynameistaken1/drupal-base:0.1.0 as only-drupal

# WORKDIR /root/.config/drupal
# COPY ./initialize-repository.sh .
# COPY ./existing-repository.sh .
# COPY ./php/settings.txt .
# COPY .gitignore .
# RUN apk add postgresql-client bash git


# # -------------------------------------------------------

# # xdebug-base is pushed to everynameistaken1/xdebug-base
# # Image adds debugger package, sets shared config values and
# # exposes correct port.
# FROM only-drupal as xdebug-base
# # FROM everynameistaken1/only-drupal:0.1.0 as xdebug-base

# RUN install-php-extensions xdebug
# COPY ./ini/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# EXPOSE 9003


# # -------------------------------------------------------

# # xdebug-vscode is pushed to everynameistaken1/xdebug-vscode
# # Image adds correct setting for debugger so that vscode
# # can communicate with it.
# FROM xdebug-base as xdebug-vscode
# # FROM everynameistaken1/xdebug-base:0.1.0 as xdebug-vscode
# RUN echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


# # -------------------------------------------------------

# # xdebug-nvim is pushed to everynameistaken1/xdebug-nvim
# # Image adds neccessary packages for neovim setup to function
# # properly.
# FROM xdebug-base as xdebug-nvim
# # FROM everynameistaken1/xdebug-base:0.1.0 as xdebug-nvim

# RUN apk add neovim neovim-doc make gcc unzip wget gzip nodejs npm fd  \
#     ripgrep curl python3 py3-pip linux-headers \
#     alpine-sdk build-base

# RUN npm install -g neovim
# RUN pip3 install pynvim

# WORKDIR /root/.config

# RUN git clone -b "0.1.0" --single-branch https://github.com/everynameistaken1/nvim.git nvim
# RUN git clone https://github.com/xdebug/vscode-php-debug.git vscode-php-debug && \
#     cd vscode-php-debug && \
#     npm install && npm run build

# WORKDIR /root/.config/drupal