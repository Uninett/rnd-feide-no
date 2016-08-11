#! /bin/bash



echo "mysqldump -u ${DBUSER} --password="xxx" -h ${DBHOST} ${DBNAME}"
echo "mysql -u ${TESTING_DBUSER} --password="xxx" -h ${TESTING_DBHOST} ${TESTING_DBNAME}"

echo "mysqldump -u ${WORDPRESS_DB_USER_PROD} --password=\"${WORDPRESS_DB_PASSWORD_PROD}\" -h ${WORDPRESS_DB_HOST}  ${WORDPRESS_DB_NAME_PROD} | mysql -u ${WORDPRESS_DB_USER} --password=\"${WORDPRESS_DB_PASSWORD_PROD}\" -h ${WORDPRESS_DB_HOST} ${WORDPRESS_DB_NAME}"

# mysqldump --add-drop-database -u ${DBUSER} --password="${DBPASSWORD}" -h ${DBHOST} ${DBNAME} | mysql -u ${TESTING_DBUSER} --password="${TESTING_DBPASSWORD}" -h ${TESTING_DBHOST} ${TESTING_DBNAME}
# echo "mysqldump -u $WORDPRESS_DB_USER"