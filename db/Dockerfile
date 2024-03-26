#  Changed from 14
FROM postgres:16 as postgres

COPY ./pg_trgm.sh /docker-entrypoint-initdb.d

FROM mysql:8 as mysql

COPY ./my.cnf /etc/mysql/conf.d/my.cnf