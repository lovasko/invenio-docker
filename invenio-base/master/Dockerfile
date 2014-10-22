# base invenio image of the master branch 
FROM ubuntu:14.04
MAINTAINER Daniel Lovasko <daniel.lovasko@cern.ch>

# set the apache2 variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# update the repository sources list
RUN apt-get update

# install git-core
RUN apt-get install -y git wget

# create and change into code/ directory
RUN mkdir code
WORKDIR code

# download the invenio kickstart scripts
RUN git clone https://github.com/tiborsimko/invenio-devscripts.git

# download the invenio software
RUN git clone --branch master https://github.com/inveniosoftware/invenio.git

# tell git remote that we want all pull requests too
WORKDIR invenio
RUN git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'

# fetch all pull requests
RUN git fetch origin
WORKDIR ..

# setup environment for invenio
RUN invenio-devscripts/invenio-kickstart --yes-i-know --yes-i-really-know

