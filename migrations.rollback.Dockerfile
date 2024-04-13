FROM liquibase/liquibase

COPY ./src/main/resources/db /liquibase/migrations

CMD ["sh", "-c", "docker-entrypoint.sh --url=${URL} --contexts=${CONTEXTS} --username=${USERNAME} --password=${PASSWORD} --classpath=/liquibase/migrations --changeLogFile=changelog.xml --logLevel=FINE rollback --tag=${gitTag}"]

