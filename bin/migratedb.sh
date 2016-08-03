#! /bin/bash

export DBHOST=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbhost"}}' | base64 --decode`
export DBNAME=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbname"}}' | base64 --decode`
export DBUSER=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbuser"}}' | base64 --decode`
export DBPASSWORD=`kubectl --namespace production get secrets feidernd  -o 'go-template={{index .data "dbpassword"}}' | base64 --decode`
export TESTING_DBHOST=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbhost"}}' | base64 --decode`
export TESTING_DBNAME=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbname"}}' | base64 --decode`
export TESTING_DBUSER=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbuser"}}' | base64 --decode`
export TESTING_DBPASSWORD=`kubectl --namespace production get secrets feidernd-testing  -o 'go-template={{index .data "dbpassword"}}' | base64 --decode`
echo "mysqldump -u ${DBUSER} --password="xxx" -h ${DBHOST} --all-databases"
echo "mysql -u ${TESTING_DBUSER} --password="xxx" -h ${TESTING_DBHOST} ${TESTING_DBNAME}"

# - mysqldump -u ${DBUSER} --password="${DBPASSWORD}" -h ${DBHOST} --all-databases | mysql -u ${TESTING_DBUSER} --password="${TESTING_DBPASSWORD}" -h ${TESTING_DBHOST} ${TESTING_DBNAME}
