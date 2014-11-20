#!/bin/bash
# run the docker fast-feature-test master image

set -x

if [[ "${1}" == "debug" ]]
then
  sudo docker run -t -i --entrypoint=/bin/bash fast-feature-test:master -s
else
  # assure the existence of the output directory 
  sudo mkdir -p output

  # TODO get the document directory, not the cwd
  sudo docker run -h invenio -v `pwd`/output:/output \
    fast-feature-test:master "$@"
fi

