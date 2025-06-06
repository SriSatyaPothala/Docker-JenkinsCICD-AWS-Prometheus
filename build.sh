#!/bin/bash

# script is used to do the following two tasks
# written by Sri Satya Pothala on 06.06.2025
# 1. building docker image from dockerfile in the current directory
# 2. pushing the docker image to dockerhub
# Environmental variables needed are DOCKER_HUB_USERNAME and DOCKER_HUB_PASSWORD 
# should be provided by jenkins environment
DOCKER_USERNAME="${DOCKER_HUB_USERNAME}" 
DOCKER_PASSWORD="${DOCKER_HUB_PASSWORD}"
#${DOCKER_REPO_NAME}--> this is coming as an arg for the script
if [ -z "$1" ]; then
    echo "ERROR: Missing Docker repository name"
    echo "Example: $0 john/react-app build-1"
    exit 1 
fi 
DOCKER_REPO_NAME="$1"
IMAGE_NAME="${DOCKER_REPO_NAME}:${BUILD_NUMBER}"
echo "Building the docker image..."
docker build -t "${IMAGE_NAME}" . 
# u need to check if build succeeded
if [ $? -ne 0 ]; then 
    echo "ERROR: Docker Image build failed"
    exit 1
fi
echo "Image built successfully!"
echo "Logging in to docker hub..."
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin 
# u need to check if login succeeded
if [ $? -ne 0 ]; then 
    echo "ERROR: Docker Login failed"
    exit 1
fi
echo "Login Successful!"
echo "Pushing Docker Image to dockerhub"
docker push "${IMAGE_NAME}"
if [ $? -ne 0 ]; then 
    echo "ERROR: Docker push failed"
    exit 1
fi
echo "Image pushed successfully: ${IMAGE_NAME}"
