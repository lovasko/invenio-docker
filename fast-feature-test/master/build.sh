#!/bin/bash
# build script for the fast-feature-test:master  Docker image

set -x
sudo docker build --no-cache=true -t fast-feature-test:master .

