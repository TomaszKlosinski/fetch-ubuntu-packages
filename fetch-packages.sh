#!/bin/bash
# fetch-packages.sh: a script used for downloading Ubuntu packages with dependencies

# requirements: docker

# global variables
readonly FULL_PATH=$( realpath $0 || readlink -f $0 ) # full path to this script
readonly DIR=${FULL_PATH%/*} # the directory where the script is
readonly CWD="$( pwd )" # the directory where the script is invoked
readonly CONTAINER_MOUNT_POINT="/mnt/" # where the current directory should be mounted in the container
readonly PACKAGE=$1 # name of the package
readonly ADDITIONAL_REPOSITORIES=${2// /,} # comma-seperated list of additional repositories

# when the script exits, go back to the directory where the script was invoked
trap "cd $CWD" EXIT INT TERM

# define help function dispalying usage
function usage() {
	echo -e "\nUsage: $0 package_name [additional_repo1,additional_repo2]"
  echo -e "\nNOTE: Script requires docker to be installed and configured."
	exit 1
}

# main logic of the script
cd $DIR

# check number of arguments (required at least 1, but not more than 2)
if [  $# -le 0 ] || [ $# -gt 2 ]; then
	usage
	exit 1
fi

# check if docker is installed
if ! [ -x "$(command -v docker)" ]; then
    echo -e "\nError: Command 'docker' not found."
    echo -e "\nThis script requires docker to be installed and configured."
    exit 127
fi

# run docker container with mounted current directory and execute script that
# downloads the package and recursively all dependencies
echo -e "Running docker container to execute script that downloads the packages."
docker run -v ${DIR}:${CONTAINER_MOUNT_POINT} -i -t ubuntu:latest \
	bash -x -c "cd $CONTAINER_MOUNT_POINT && bash -x ${CONTAINER_MOUNT_POINT}/lib/download-packages-with-dependencies.sh $PACKAGE $CONTAINER_MOUNT_POINT $ADDITIONAL_REPOSITORIES"
