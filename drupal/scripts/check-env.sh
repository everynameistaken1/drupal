#!/usr/bin/env bash

# Checks if all neccessary environment variables are set.

# Exit on errors.
set -euo pipefail


# Error if values not set.
echo "Checking if there are unset variables, please wait..."
if [ -z "$PROJECT_NAME" ]; then echo "Error: PROJECT_NAME can't be empty or unset" && exit 1; fi
if [ -z "$CLONE_REPOSITORY" ]; then echo "Error: CLONE_REPOSITORY can't be empty or unset" && exit 1; fi
if [ -z "$COMPOSER_CREATE_REPOSITORY" ]; then echo "Error: COMPOSER_CREATE_REPOSITORY can't be empty or unset" && exit 1; fi
if [ -z "$ACCOUNT_NAME" ]; then echo "Error: ACCOUNT_NAME can't be empty or unset" && exit 1; fi
if [ -z "$ACCOUNT_MAIL" ]; then echo "Error: ACCOUNT_MAIL can't be empty or unset" && exit 1; fi
if [ -z "$SITE_MAIL" ]; then echo "Error: SITE_MAIL can't be empty or unset" && exit 1; fi
if [ -z "$SITE_NAME" ]; then echo "Error: SITE_NAME can't be empty or unset" && exit 1; fi
if [ -z "$DATABASE_CHOICE" ]; then echo "Error: DATABASE_CHOICE can't be empty or unset" && exit 1; fi
if [ -z "$DB_USER" ]; then echo "Error: DB_USER can't be empty or unset" && exit 1; fi
if [ -z "$DB_HOST" ]; then echo "Error: DB_HOST can't be empty or unset" && exit 1; fi
if [ -z "$DB_DATABASE_NAME" ]; then echo "Error: DB_DATABASE_NAME can't be empty or unset" && exit 1; fi
if [ -z "$TABLE_EXISTS" ]; then echo "Error: TABLE_EXISTS can't be empty or unset" && exit 1; fi
if [ -z "$GIT_USERNAME" ]; then echo "Error: GIT_USERNAME can't be empty or unset" && exit 1; fi
if [ -z "$GIT_EMAIL" ]; then echo "Error: GIT_EMAIL can't be empty or unset" && exit 1; fi
if [ -z "$XDEBUG_MODE" ]; then echo "Error: XDEBUG_MODE can't be empty or unset" && exit 1; fi
