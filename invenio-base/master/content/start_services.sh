#!/bin/bash
# start services needed for invenio

service mysql start
service redis-server start

# default behaviour is to start apache2 in background
if [[ ${1} = "--apache-in-foreground" ]]
then
  apache2ctl -D FOREGROUND
else
  service apache2 start
fi

