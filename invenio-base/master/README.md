Invenio base image
==================

### Root directory workaround
Currently, Docker is having problems with changing working directory to `/`.
Hence `invenio/` and `invenio-devscripts/` are being manipulated in the 
`/code/` directory. This might (but also might not) change in future versions.
