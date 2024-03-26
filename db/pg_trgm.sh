#!/bin/bash

echo "Checking if table <$TABLE_EXISTS> exists ...";

if [ $(psql -At -U $DB_USER -d $DB_DATABASE_NAME -c "SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_name = '$TABLE_EXISTS' ) AS table_existence;") = "t" ]
  then
    echo "Database already initialized..."
  else
    # Extension is neccessary for drupal.
    psql -U $DB_USER -d $DB_DATABASE_NAME -c "CREATE EXTENSION pg_trgm;"
fi