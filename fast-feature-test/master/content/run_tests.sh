#!/bin/bash
# run the invenio master tests

function usage()
{
  echo "Usage: run_tests.sh -h | --help | branch_name | pull_request_id"
  exit 1
}

# run various tests only once while always recreating the database
function primitive_run_tests()
{
  # stop apache to prevent data race
  service apache2 stop

  # recreate demo site
  /code/invenio-devscripts/invenio-recreate-demo-site --yes-i-know

  # craete almost unique file name that consists of the pull request 
  # ID and a timestamp
  TEST_OUTPUT="${1}-`date +%s`"

  # run the both test suites
  sudo -u www-data nosetests --with-xunit --xunit-file=/output/"$TEST_OUTPUT" \
    /opt/invenio/lib/python/invenio/*_unit_tests.py \
    /opt/invenio/lib/python/invenio/*_regression_tests.py

  RESULT=$?
}

# run various test suites
# @param 1 recreate demo-site on failure
function run_tests()
{
  # run unit tests and fail globally upon first single failure
  sudo -u www-data nosetests -x /opt/invenio/lib/python/invenio/*_unit_tests.py

  if [[ "$?" != 0 ]]
  then
    if [[ "${1}" = true ]]
    then 
      /code/invenio-devscripts/invenio-recreate-demo-site --yes-i-know
      run_tests false 
    else
      exit 3
    fi
  fi

  # run regression tests and fail globally upon first single failure
  sudo -u www-data nosetests \
    /opt/invenio/lib/python/invenio/*_regression_tests.py

  if [[ "$?" != 0 ]]
  then
    if [[ "${1}" = true ]]
    then 
      /code/invenio-devscripts/invenio-recreate-demo-site --yes-i-know
      run_tests false 
    else
      exit 4
    fi
  fi

  echo "All tests run successfully."
  exit 0
}

# detect wrong argument count or help message
# @param 1 parameter list
function parse_arguments()
{
  if [[ "$#" != 1 || "${1}" = "-h" || "${1}" = "--help" ]]
  then
    usage
  fi
}

# determine whether the branch is a pull request or not
# @param 1 branch name or pull request ID
function determine_pattern()
{
  # assume branch
  pattern=normal

  # check for an integer starting with a non-null digit - a PR number
  if [[ "${1}" =~ ^[1-9][0-9]*$ ]]
  then
    pattern=pull_request
  fi
}

# checkout the appropriate branch
# @param 1 branch name or pull request ID
function checkout_branch()
{
  if [[ "${pattern}" = "normal" ]]
  then
    # test for existence
    if ! git show-ref --verify --quiet refs/heads/"${1}"
    then
      echo "ERROR: no such branch '${1}'"
      exit 2
    fi

    # perform the checkout
    echo "Checking out the branch ${1}."
    git checkout "${1}"

  elif [[ "${pattern}" = "pull_request" ]]
  then
    # test for existence
    if ! git show-ref --verify --quiet refs/remotes/origin/pr/"${1}"
    then
      echo "ERROR: no such pull request '${1}'"
      exit 2
    fi

    # perform the checkout
    echo "Checking out the pull request #${1}."
    git checkout "pr/${1}"
  fi
}

# install changes made in the feature branch 
function install_branch()
{
  (cd /code/invenio && /code/invenio-devscripts/invenio-make-install)
}

# enable access to the output directory
chmod 777 /output

parse_arguments $@
determine_pattern $@
checkout_branch $@
install_branch
/start_services.sh
# run_tests false
primitive_run_tests $@

exit "${RESULT}"
