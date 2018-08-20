#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"

if [ "$#" -ne 1 ]; then
    echo "No action defined"
    exit 1
fi

logMsg "Start"
MYSQL_ROOT_PASSWORD=$(dockerExecMySQL printenv MYSQL_ROOT_PASSWORD)
MYSQL_DATABASE=$(dockerExec printenv MYSQL_DATABASE)
MYSQL_USER=$(dockerExec printenv MYSQL_USER)

case "$1" in
    "create")
        if [[ -n "$(dockerContainerId mysql)" ]]; then
            logMsg "Create New DB..."
            echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; \
            GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'%' WITH GRANT OPTION; \
            FLUSH PRIVILEGES; \
            " | dockerExecMySQL sh -c "MYSQL_PWD=\"${MYSQL_ROOT_PASSWORD}\" mysql -h mysql -uroot"
            logMsg "Finished"
        else
            echo " * Skipping, no such container"
        fi
        ;;

    "drop")
        if [[ -n "$(dockerContainerId mysql)" ]]; then
            logMsg "Cleanup DB..."
            echo "DROP DATABASE IF EXISTS ${MYSQL_DATABASE}; \
            REVOKE ALL PRIVILEGES ON ${MYSQL_DATABASE}.* FROM ${MYSQL_USER}@'%'; \
            REVOKE GRANT OPTION ON ${MYSQL_DATABASE}.* FROM ${MYSQL_USER}@'%'; \
            FLUSH PRIVILEGES; \
            " | dockerExecMySQL sh -c "MYSQL_PWD=\"${MYSQL_ROOT_PASSWORD}\" mysql -h mysql -uroot"
            logMsg "Finished"
        else
            echo " * Skipping, no such container"
        fi
        ;;
esac
