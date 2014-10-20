# fast feature testing image based on the base invenio image
FROM invenio-base:master
MAINTAINER Daniel Lovasko <daniel.lovasko@cern.ch>

# main testing script
ADD content/run_tests.sh /

# get all new branches (note that we are already in the code/ directory)
WORKDIR invenio
RUN git fetch origin

# default branch to be tested is "master"
CMD "master"

# run the tests
ENTRYPOINT ["/run_tests.sh"]

