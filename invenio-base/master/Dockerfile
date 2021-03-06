# base invenio image of the master branch 
FROM ubuntu:14.04
MAINTAINER Daniel Lovasko <daniel.lovasko@cern.ch>

# set the global hostname
ENV HOSTNAME localhost 

# set the apache2 variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# set the invenio variables
ENV CFG_INVENIO_HOSTNAME localhost 
ENV CFG_INVENIO_DOMAINNAME localhost
ENV CFG_INVENIO_SRCDIR /code/invenio
ENV CFG_INVENIO_ADMIN root@localhost

# WORKAROUND: invenio-setup-environment checks for the presence of the
#             CFG_INVENIO_HOSTNAME variable in the .bashrc file and
#             adds one, when not is present. This results into using
#             the hostname of the machine during building the image,
#             which in turn sets the variable to an unacceptable random
#             SHA value during the build execution.
RUN echo "export CFG_INVENIO_HOSTNAME=localhost" >> /.bashrc
RUN echo "export CFG_INVENIO_DOMAINNAME=localhost" >> /.bashrc
RUN echo "export CFG_INVENIO_SRCDIR=/code/invenio" >> /.bashrc
RUN echo "export CFG_INVENIO_ADMIN=root@localhost" >> /.bashrc

# update the repository sources list
RUN apt-get update

# install git-core
# WORKAROUND: Currently, invenio is checking the apache2 version by
#             using `locate` to search the executable, followed by
#             grep-ing out the version string. There is a faulty 
#             assumption that the locate package is installed on
#             every system and that `updatedb` is triggered by the
#             package manager. We need to install both locate and 
#             apache2 before kickstarting invenio, in order to have
#             the apache2 binary already in the locate database.
RUN apt-get install -y git wget locate apache2

# update the locate database
RUN updatedb

# create and change into code/ directory
# WORKAROUND: Docker is having problems with changing working directory
#             to `/`. Hence `invenio/` and `invenio-devscripts/` are 
#             being manipulated in the `/code/` directory. This might 
#             (but also might not) change in future versions.
RUN mkdir code
WORKDIR code

# download the invenio kickstart scripts
RUN git clone https://github.com/tiborsimko/invenio-devscripts.git

# download the invenio software
RUN git clone --branch master https://github.com/inveniosoftware/invenio.git

# tell git remote that we want all pull requests too
WORKDIR invenio
RUN git config --add remote.origin.fetch \
  '+refs/pull/*/head:refs/remotes/origin/pr/*'

# fetch all pull requests
RUN git fetch origin
WORKDIR ..

# expose HTTP and HTTPS ports
EXPOSE 80
EXPOSE 443

# setup environment for invenio
RUN invenio-devscripts/invenio-kickstart --yes-i-know --yes-i-really-know

# add the service starting script
ADD content/start_services.sh /start_services.sh

# set it as an entry point
ENTRYPOINT ["/start_services.sh"]

