# base invenio image of the master branch 
FROM ubuntu:14.04
MAINTAINER Daniel Lovasko <daniel.lovasko@cern.ch>

# update the repository sources list
RUN apt-get update

# install git-core
RUN apt-get install -y git wget

# download the invenio kickstart scripts
RUN git clone https://github.com/tiborsimko/invenio-devscripts.git

# download the invenio software
RUN git clone --branch master https://github.com/inveniosoftware/invenio.git

# setup environment for invenio
RUN invenio-devscripts/invenio-kickstart --yes-i-know --yes-i-really-know

