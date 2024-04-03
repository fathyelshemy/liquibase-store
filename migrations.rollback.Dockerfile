FROM liquibase/liquibase:4.9

COPY ./src/main/resources/dbmigrations /liquibase/changelog

CMD ["sh", "-c", "docker-entrypoint.sh --url=${URL} --contexts=${CONTEXTS} --username=${USERNAME} --password=${PASSWORD} --classpath=/liquibase/changelog --changeLogFile=changelog.xml --logLevel=FINE rollback ${gitTage}"]

