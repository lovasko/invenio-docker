#!/bin/bash
# build script for the invenio-base:master Docker image

# ensure one non-empty argument
# TODO we might want to check for [a-zA-Z0-9]*
if [[ $# != 1 || -z ${1} ]]
then
  echo "Usage: ./build.sh TAG"
  exit 1
fi

set -x
sudo docker build --no-cache=true -t invenio-base-master:"$1" .

