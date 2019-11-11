[![Build Status](https://travis-ci.com/Otus-DevOps-2019-08/SergeyKa-cmd_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2019-08/SergeyKa-cmd_microservices)
# SergeyKa-cmd_microservices
## Contents:
  # 1. Docker: first look
  # 2. Docker: docker containers
______________________________________________________________
## 1. Docker: first look
### Main issue: docker host & image creation, docker hub registry
### Additional task: docker container and docker image files comparison
## System prerequisites
  + Prepare for [Docker environment](https://docs.docker.com/install/linux/docker-ce/ubuntu/);
  + Prepare for [Docker Compose](https://docs.docker.com/compose/install/);
## App testing for additional task:
  + Comparing two files: inspect_container.json and inspect_image.json using commands:
    
    $docker inspect <CONTAINER ID> > inspect_container.json
    
    $docker inspect <IMAGE ID> > inspect_image.json
  
    $diff inspect_image.json inspect_container.json
  + Save all comparison information and docker images result to file docker-1.log:
  
    $docker images > docker-1.log
_____________________________________________________________________________________________________________________________
## 2. Docker: docker containers
### Main issue: Docker integration to GCE and Docker Hub
### Additional task: Up and running instances in GCE using Packer & Terraform & Ansible with docker image from Docker Hub
## System prerequisites:
  + Create new project in [GCE](https://console.cloud.google.com/compute)
  + Prepare for [GCloud SDK](https://cloud.google.com/sdk/) on local machine
  + Register on [Docker Hub](https://hub.docker.com/)
 ## App testing for additional task:
  + Clone current preository and prepare own packer/variables.json and terraform/stage/variables.tf files
  + Check that app is up and running via docker run:
  
    $docker run --name reddit -d -p 9292:9292 sergeykacmd/otus-reddit:1.0
  + Checkout current inventory in [Google Cloud Console](https://console.cloud.google.com/compute)
  + Run Packer & Terraform & Ansible commands:
  
    $packer buid -var-file=variables.json app.json && packer buid -var-file=variables.json db.json
    
    $terraform apply
    
    $ansible-playbook playbooks/site.yml
_____________________________________________________________________________________________________________________________
