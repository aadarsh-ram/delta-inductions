# Task 2 Summary

This is the folder for task 2 of the "Omega Bank Server Setup" for Delta SysAd Inductions 2022.

## Prerequisites
- Docker CE
- Docker Compose

## Quick Setup

### Clone the repo
```
git clone https://github.com/aadarsh-ram/delta-inductions-sysad.git
cd delta-inductions-sysad/task2
```

### Start Apache Server on host machine
To start the Apache Web Server on your host machine, use the following command:
```
bash scripts/apache.sh
```
> Uncomment lines 9 and 10 in apache.sh if you're running the script for the first time. 
> Substitute <ip_address> with your host machine IP Address.
> Comment above lines for subsequent runs.

### Start Docker Container
To start the docker container for Omega Server, simply use the below command:
```
docker-compose up
```

## Check it out!
Visit `omega.com` in a web-browser of your choice to check out the summary files created for each branch.

A sample file `summary_Branch1.txt` has already been created and kept for your convenience.

If no summary files exist, you can create the summary files with `genSummary.sh` by logging into the Docker container using the command:
```
docker exec -it task2-docker-server-1 bash
``` 