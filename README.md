#Gitolite on docker

## How to run
There are two methods to run this image.

1. Use `docker run` directly. Example:

        $ docker run -d -p 2222:22 --name gitolite -e SSH_KEY="$(cat  ~/.ssh/id_rsa.pub)"  -v /path/to/git/data:/home/git/repositories  betacz/gitolite
		
2. Use the `gitolite` script from the [GitHub Project](https://github.com/hlj/dockerfiles/blob/master/gitolite/gitolite).

	This script contains the following variables. You can change them by modifying this file or by use the environment variable to override.
	
        IMAGE_NAME			default: "betacz/gitolite"
        CONTAINER_NAME  	default: "gitolite-server"
        PORT                default: "2222"
        GIT_DATA_PATH       default: "/opt/git"
        SSH_KEY_FILE        default: "$HOME/.ssh/id_rsa.pub"
     
    Example:
	
        # run the container
        $ GIT_DATA_PATH=/var/data/git ./gitolite start
        # stop && remove the container
        $ ./gitolite stop && ./gitolite remove
     
    The user running the script must be a member of the group `docker`. Otherwise, you need to modify this script and prepend `sudo` to the appropriate command.

**Attention:**

 - If you don't use your own ssh key, you can get the built-in private key by `docker logs gitolite` for admin user.

 - You should create a directory for persistent Git repositories. This directory must have read/write permissions for current user. 

 - The Git repositories directory you specify can also be a already exists gitolite repositories. 

## .rc file
You can customize the gitolite `.rc` file by modify the `/path/to/git/data/gitolite.rc`. This file will sync to `~/.gitolite.rc`  when restart the container. So after change it you must run command like this:

       $ ./gitolite stop && ./gitolite start

## Container removed?
If the container accidentally removed by `docker rm` or `./gitolite remove` . You can start it with the command as same as before. But you must force push the `gitolite-admin` again. 

Example:

       $ GIT_DATA_PATH=/var/data/git ./gitolite start
       $ cd ~/gitolite-admin && git push -f

## Build your own image
Clone the source code and run:

       $ docker build -t gitolite .
