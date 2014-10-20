#!/bin/bash
# run the docker fast-feature-test master image

set -x
sudo docker run fast-feature-test:master "$@"

