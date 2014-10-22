# Invenio master base image
Dockerized version of the Invenio software - master branch. This image
contains Apache2, MySQL server and Redis server in the same container.
The [official invenio repository](www.github.com/inveniosoftware/invenio) 
is used as a source for the source code. Tibor Simko's
[devscripts](www.github.com/tiborsimko/invenio-devscripts) are used to
setup the environment and create the testing database/website.

## Build
Run the `build.sh` script without any arguments to build the Docker
image `invenio-base:master` based on the `ubuntu:14.04` image.

## Run
Run the `run.sh` script that takes two arguments: HTTP and HTTPS port
numbers.  By default the image is started with Apache2 in the
background, while this wrapper script passes the
`--apache-in-foreground` option.

