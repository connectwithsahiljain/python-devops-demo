#!/bin/bash
# Deployment script for python-devops-demo
# Called by Jenkins via AWS SSM - DEPLOY_IMAGE is substituted at pipeline runtime

docker pull DEPLOY_IMAGE
docker stop python-app || true
docker rm python-app || true
docker run -d -p 5000:5000 --name python-app DEPLOY_IMAGE
