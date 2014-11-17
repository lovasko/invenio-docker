#!/bin/bash
# run the invenio-base: master image

if [[ $# != 2 ]]
then
  echo "Wrong number of arguments."
  echo "Usage: ./run.sh HTTP_PORT HTTPS_PORT"
  exit 1
fi

set -x
sudo docker run -p "${1}":80 -p "${2}":443 -h localhost\
  invenio-base:master --apache-in-foreground

