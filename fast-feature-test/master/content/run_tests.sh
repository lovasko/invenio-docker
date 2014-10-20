#!/bin/bash
# run the invenio master tests

function usage()
{
  echo "Usage: run_tests.sh -h | --help | branch_name | pull_request_id"
  exit 1
}

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
  sudo -u www-data nosetests -x \
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

function parse_arguments()
{
  # check input parameters
  if [[ "$#" != 1 || "${1}" = "-h" || "${1}" = "--help" ]]
  then
    usage
  fi
}

function determine_pattern()
{
  # determine whether the branch is a PR or not
  # assume branch
  pattern=normal

  # check for an integer starting with a non-null digit - a PR number
  if [[ "${1}" =~ ^[1-9][0-9]*$ ]]
  then
    pattern=pull_request
  fi
}

function checkout_branch()
{
  # checkout the appropriate branch
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

function install_branch()
{
  # install the feature branch 
  /code/invenio-devscripts/invenio-make-install
}

parse_arguments
determine_pattern
checkout_branch
install_branch
run_tests true

