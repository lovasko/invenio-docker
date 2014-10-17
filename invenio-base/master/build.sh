#!/bin/bash
# build script for the invenio-base:master Docker image

set -x
sudo docker build --no-cache=true -t invenio-base:master .

