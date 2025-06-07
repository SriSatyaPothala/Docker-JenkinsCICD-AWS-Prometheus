#!/bin/bash
## script is used to do the following two tasks
# written by Sri Satya Pothala on 07.06.2025
# 1. pulling docker image from the docker private hub repository
# 2. running docker container with the application of docker image
# following should be provided by jenkins environment
#${IMAGE_NAME}--> this is coming as an arg for the script
#${CONTAINER_NAME}--> this is coming as second arg for the script
#${HOST_PORT}--> this is coming as third arg for the script

IMAGE_NAME="$1"
CONTAINER_NAME="$2"
HOST_PORT="${3:-80}" #if third parameter is passed set the value otherwise set the value as 80

if [ -z "${IMAGE_NAME}" ] || [ -z "${CONTAINER_NAME}" ]; then
   echo "ERROR: Missing required arguments either IMAGE_NAME OR CONTAINER_NAME NOT SET"
   echo "USAGE: $0 rep/react-app:latest react-prod-app"
   exit 1
fi 
echo "Deployment started..."
echo "Pulling docker image..."
docker pull "${IMAGE_NAME}"
if [ $? -ne 0 ]; then
  echo "ERROR: failed pulling the docker image"
  exit 1
fi 
echo "Image pulled Successfully!"
#Stop and remove any previously running old containers
docker stop "${CONTAINER_NAME}" || true 
docker rm "${CONTAINER_NAME}" || true 
echo "Starting docker container..."
docker run -d --name "${CONTAINER_NAME}" -p "${HOST_PORT}":80 "${IMAGE_NAME}"
if [ $? -ne 0 ]; then 
    echo "FAILED: Running the Container"
    exit 1
fi 
echo "Container '${CONTAINER_NAME}' launched successfully"
echo "---Deployment Finished---"
