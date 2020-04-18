#!/bin/bash

echo "Welcolme to database preparing script.
I'll help you to create new database with user for your project
====
"

echo "Enter database name: "
read DBNAME

DBUSER="${DBNAME}_user"

# create random password
DBUSERPASS="$(openssl rand -base64 3)-$(openssl rand -base64 3)-$(openssl rand -base64 3)-$(openssl rand -base64 3)"

echo "Creating new database and user"

# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then
    mysql -e "CREATE DATABASE ${DBNAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${DBUSER}@localhost IDENTIFIED BY '${DBUSERPASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password
else
    echo "Please enter root user MySQL password first"
    echo "*Note: password will be hidden when typing"
    read -sp rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${DBNAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${DBUSER}@localhost IDENTIFIED BY '${DBUSERPASS}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
fi

echo "Created new database: ${DBNAME}
        and user: ${DBUSER}
        password: ${DBUSERPASS}"


echo "DONE
P.S. Don't forget to add credentials to .env"
