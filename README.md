# fetch-ubuntu-packages
Script using docker container to fetch Ubuntu packages with dependencies

# Requirements
- [Docker](https://www.docker.com)

# Usage
For example, to download Ansible with all dependencies run:

    $ ./fetch-packages.sh ansible
    
You can find downloaded packages in `./packages/` directory. 
