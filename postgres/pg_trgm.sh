#!/bin/bash

echo "Checking if table <$TABLE_EXISTS> exists ...";

if [ $(psql -At -U $POSTGRES_USER -d $POSTGRES_DB -c "SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_name = '$TABLE_EXISTS' ) AS table_existence;") = "t" ]
  then
    echo "Database already initialized..."
  else
    psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE EXTENSION pg_trgm;"
fi