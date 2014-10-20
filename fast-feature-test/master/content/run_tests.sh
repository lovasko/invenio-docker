#!/bin/bash
# run the invenio master tests

function usage()
{
  echo "Usage: run_tests.sh -h | --help | branch_name | pull_request_id"
  exit 1
}

# check input parameters
if [[ "$#" != 1 || "${1}" = "-h" || "${1}" = "--help" ]]
then
  usage
fi

# determine whether the branch is a PR or not
# assume branch
pattern=normal

# check for an integer starting with a non-null digit - a PR number
if [[ "${1}" =~ ^[1-9][0-9]*$ ]]
then
  pattern=pull_request
fi

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

# run the tests (work in progress)
#sudo -u www-data nosetests /opt/invenio/lib/python/invenio/*_unit_tests.py
#sudo -u www-data nosetests /opt/invenio/lib/python/invenio/*_regression_tests.py

exit 0

