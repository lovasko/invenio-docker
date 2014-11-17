#!/bin/bash
# run the docker fast-feature-test master image

set -x

if [[ "${1}" == "debug" ]]
then
  sudo docker run -t -i --entrypoint=/bin/bash fast-feature-test:master -s
else
  sudo docker run -h invenio fast-feature-test:master "$@"
fi

