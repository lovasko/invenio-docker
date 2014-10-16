DNS setup
=========

As it turns out, proper configuration of network tends to get difficult.
Currently, running Docker inside a huge network (like CERN's) is messing up the
DNS records. In order to be able to `ping google.com` from inside of your
container, you need to edit the file `/etc/default/docker.io` in a following 
manner:
```
...
DOCKER_OPTS="--dns 137.138.16.5 --dns 137.138.17.5 --dns 8.8.8.8 --dns 8.8.4.4"
...
```
The specific IP addresses can be found
[here](http://service-dns.web.cern.ch/service-dns/cerndns.asp).

Afterwards, you need to `service docker.io restart` and you are good to go.
