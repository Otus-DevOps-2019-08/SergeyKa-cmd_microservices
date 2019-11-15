[![Build Status](https://travis-ci.com/Otus-DevOps-2019-08/SergeyKa-cmd_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2019-08/SergeyKa-cmd_microservices)
# SergeyKa-cmd_microservices
## Contents:
  # 1. Docker: First look
  # 2. Docker: Containers & Images maintain
  # 3. Docker: Images & Microservices
______________________________________________________________
## 1. Docker: First look
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
## 2. Docker: Containers & Images maintain
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
## 3. Docker: Images & Microservices
### Main issue: Decomposition of application for microservice environment
### Additional task: Tuning current dockerfiles: changing network aliases; using Alpine Linux packages for post, comment and ui.
## System prerequisites:
  + Prepare for [GCloud SDK](https://cloud.google.com/sdk/) on local machine
  + Register on [Docker Hub](https://hub.docker.com/)
 ## App testing:
  + Clone current repository to your environment
  + Ensure that your docker host up and running via terminal:

    $ docker-machine ls
  + Create docker images using terminal:
    
    $ docker build -t your-dockerhub-login/post:1.0 ./post-py
    
    $ docker build -t your-dockerhub-login/comment:1.0 ./comment
    
    $ docker build -t your-dockerhub-login/ui:1.0 ./ui
  + Create your private network:
    
    $ docker network create
  + Finally run containers for app:
    
    $ docker run -d --network=your-network-tag --network-alias=post_db --network-alias=comment_db mongo:latest
    
    $ docker run -d --network=your-network-tag --network-alias=post your-dockerhub-login/post:1.0
    
    $ docker run -d --network=your-network-tag --network-alias=comment your-dockerhub-login/comment:1.0
    
    $ docker run -d --network=your-network-tag -p 9292:9292 your-dockerhub-login/ui:1.0

 ## App connectivity testing:
  + Ensure that your Monolith Reddit up and running http://:9292
  + [Monolith Reddit](http://35.195.87.92:9292/) - to test my solution
__________________________________________________________________________________
