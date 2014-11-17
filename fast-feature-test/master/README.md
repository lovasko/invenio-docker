Fast feature test
=================
Fast feature testing is a method of running the Invenio test suite inside a
Docker container. This approach provides significant improvements: removing the
need to compile all packages from scratch and having a clean instance of the
user-space system. The testing overhead is therefore minimized to as little as
few seconds.

Build
-----
Run the `build.sh` script without any arguments to build the Docker
image `fast-feature-test:master` based on the `invenio-base:master`
image.

Run
---
Run the `run.sh` script to start the fast-feature testing that takes
one argument: either a branch name or a pull request ID from GitHub. 
Examples:
```
./run.sh master
./run.sh 2385
```
