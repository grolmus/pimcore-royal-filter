#!/bin/bash
set -e
set -u
set -x

function create_user_and_database() {
	local database=$1
	echo "  -> Creating database '$database'"
	mysql --user="$MYSQL_ROOT_USER" --password="$MYSQL_ROOT_PASSWORD" --execute="CREATE DATABASE IF NOT EXISTS $database;"
	mysql --user="$MYSQL_ROOT_USER" --password="$MYSQL_ROOT_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $database.* TO $MYSQL_USER;"

#	echo "  -> Set TIMEZONE for database to +1:00"
#	mysql --user="$MYSQL_ROOT_USER" --password="$MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL time_zone = \‘+1:00\’;"
}
if [ -n "$MYSQL_MULTIPLE_DATABASES" ]; then
	echo "  -> Multiple database creation requested: $MYSQL_MULTIPLE_DATABASES"

    # CREATE DATABASES
    for db in $(echo $MYSQL_MULTIPLE_DATABASES | tr ',' ' '); do
        create_user_and_database $db
    done

    # CREATE USER AND GRANT PRIVILEGES ON ALL DATABASES
#    if [ $(echo "SELECT COUNT(*) FROM mysql.user WHERE user = '$MYSQL_USER'" | mysql --user="$MYSQL_ROOT_USER" --password="$MYSQL_ROOT_PASSWORD" | tail -n1) -gt 0 ]
#    then
#        echo "      -> User '$MYSQL_USER' exists."
#    else
#        echo "      -> Creating user '$MYSQL_USER'"
#        mysql --user="$MYSQL_ROOT_USER" --password="$MYSQL_ROOT_PASSWORD" --execute="CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
#        echo "      -> Grant all privileges on $database to $MYSQL_USER"
#        for db in $(echo $MYSQL_MULTIPLE_DATABASES | tr ',' ' '); do
#            mysql --user="$MYSQL_ROOT_USER" --password="$MYSQL_ROOT_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $db.* TO '$MYSQL_USER'@'localhost'; FLUSH PRIVILEGES;"
#        done
#    fi

	echo " => Multiple databases created <= "
fi
