#!/bin/bash
# lib/download-packages-with-dependencies-using-apt-archive.sh: script to be
# excuted on a docker container to download the packages and their
# dependencies using apt cache archives

# global variables
readonly PACKAGE=$1
readonly CWD=$2
readonly OUTPUT_DIR="${CWD}/packages/"
readonly ADDITIONAL_REPOSITORIES=${3// /,} # comma-seperated list of additional repositories

# function adds ppa repositories, if specified
function add_additional_repositories() {
  if [[ ! -z $ADDITIONAL_REPOSITORIES ]]; then
    apt-get update
    apt-get install -y python-software-properties python3-software-properties software-properties-common
    for repository in $ADDITIONAL_REPOSITORIES; do
      add-apt-repository -y $repository
    done
  fi
}

# function downloads deb package and its dependencies deb packages
function download_package_with_dependencies() {
  export DEBIAN_FRONTEND=noninteractive
  add_additional_repositories

  apt-get update
  apt-get clean
  apt-get install -y --download-only $1
  mv /var/cache/apt/archives/*.deb $OUTPUT_DIR/

}


# main logic of the script
mkdir -p $OUTPUT_DIR/

# Download initial package and its dependencies
download_package_with_dependencies $PACKAGE
