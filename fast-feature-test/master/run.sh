#!/bin/bash
# run the docker fast-feature-test master image

set -x

if [[ "${1}" == "debug" ]]
then
  sudo docker run -t -i --entrypoint=/bin/bash fast-feature-test:master -s
else
  # common name for output directory
  output_folder_name="output"
  
  # local output directory 
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  output_folder_path_local="$script_dir/$output_folder_name"
  sudo mkdir -p "$output_folder_path_local"
  
  # docker output directory
  output_folder_path_docker="/$output_folder_name"

  sudo docker run -h invenio -v "$output_folder_path_local":"$output_folder_path_docker" \
    fast-feature-test:master "$@"
fi

