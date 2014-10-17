# fast feature testing image based on the base invenio image
FROM invenio-base:master
MAINTAINER Daniel Lovasko <daniel.lovasko@cern.ch>

# main testing script
ADD content/run_tests.sh /

# get all new branches
WORKDIR code/invenio
RUN git fetch origin

# default branch to be tested is "master"
CMD "master"

# run the tests
ENTRYPOINT /run_tests.sh

