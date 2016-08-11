#! /bin/bash

export DBHOST=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbhost"}}' | base64 --decode`
export DBNAME=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbname"}}' | base64 --decode`
export DBUSER=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbuser"}}' | base64 --decode`
export DBPASSWORD=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbpassword"}}' | base64 --decode`
export TESTING_DBHOST=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbhost"}}' | base64 --decode`
export TESTING_DBNAME=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbname"}}' | base64 --decode`
export TESTING_DBUSER=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbuser"}}' | base64 --decode`
export TESTING_DBPASSWORD=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbpassword"}}' | base64 --decode`



# declare -x WORDPRESS_DB_HOST
# declare -x WORDPRESS_DB_NAME
# declare -x WORDPRESS_DB_NAME_PROD
# declare -x WORDPRESS_DB_PASSWORD
# declare -x WORDPRESS_DB_PASSWORD_PROD
# declare -x WORDPRESS_DB_USER
# declare -x WORDPRESS_DB_USER_PROD


echo "mysqldump -u ${DBUSER} --password="xxx" -h ${DBHOST} ${DBNAME}"
echo "mysql -u ${TESTING_DBUSER} --password="xxx" -h ${TESTING_DBHOST} ${TESTING_DBNAME}"

mysqldump --add-drop-database -u ${DBUSER} --password="${DBPASSWORD}" -h ${DBHOST} ${DBNAME} | mysql -u ${TESTING_DBUSER} --password="${TESTING_DBPASSWORD}" -h ${TESTING_DBHOST} ${TESTING_DBNAME}
