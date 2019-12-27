[![Build Status](https://travis-ci.com/Otus-DevOps-2019-08/SergeyKa-cmd_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2019-08/SergeyKa-cmd_microservices)
## SergeyKa-cmd_microservices
### Contents:
  ### 1. Docker: First look
  ### 2. Docker: Containers & Images maintain
  ### 3. Docker: Images & Microservices
  ### 4. Docker: Networking & Docker-compose implementation
  ### 5. Gitlab: Deployment & pipeline preparations
  ### 6. Monitoring: Prometheus configuring and deployment
  ### 7. Monitoring: Monitoring system deployment & Alerting
  ### 8. Logging: Logging and distributed tracing systems
  ### 9. Kubernetes: First look & Automated deployment implementation
 ### 10. Kubernetes: Running microservices on Kubernetes cluster & GKE deployment
 ### 11. Kubernetes: Endpoint communications & Data storing policy
_______________________________________________________________________________________________________
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
_________________________________________________________________________________________________
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
  
``` docker-machine ls                                          
     NAME          ACTIVE   DRIVER   STATE     URL                       SWARM   DOCKER     ERRORS
     docker-host   -        google   Running   tcp://35.195.87.92:2376           v19.03.4 

  docker ps
    CONTAINER ID        IMAGE                     COMMAND                  CREATED              STATUS              PORTS               NAMES
    6e358cd62854        sergeykacmd/post:1.1      "python3 post_app.py"    About a minute ago   Up About a minute                       busy_kalam
    e1b43ad457de        sergeykacmd/comment:1.1   "puma"                   2 minutes ago        Up About a minute                       infallible_swanson
    3ace7552e21b        mongo:latest              "docker-entrypoint.s…"   2 minutes ago        Up 2 minutes        27017/tcp           confident_lamarr

docker images                       
    REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
    sergeykacmd/ui        1.1                 e67770bf33aa        4 minutes ago       281MB
    sergeykacmd/post      1.1                 57c520178183        5 minutes ago       109MB
    sergeykacmd/comment   1.1                 19a9095fce88        6 minutes ago       278MB
    mongo                 latest              965553e202a4        2 weeks ago         363MB
    alpine                3.10                965ea09ff2eb        3 weeks ago         5.55MB
    python                3.6.0-alpine        cb178ebbf0f2        2 years ago         88.6MB
```
 ## App connectivity testing:
  + Ensure that your Monolith Reddit up and running http://:9292
  + [Monolith Reddit](http://35.195.87.92:9292/) - to test my solution
__________________________________________________________________________________
 # 4. Docker: Networking & Docker-compose implementation
 ### Main issue: Network features discovering in docker, docker-compose implementation 
 ### Additional task: Docker-compose-override file creation
 ## System prerequisites:
  + Connect to current running GCE instance using command:
  
    $ eval $(docker-machine env docker-host)
 ## App testing:
  + Clone current repository to your environment
  + Ensure that your docker host up and running via terminal:

    $ docker-machine ls
  + Create docker container using network "none-driver":
    
    $ docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
  + Create docker container using network "host-driver":
    
    $ docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig
  + Create docker container using network "bridge-driver":

    $ docker network create reddit --driver bridge
    
    $ docker network create back_net --subnet=10.0.2.0/24
    
    $ docker network create front_net --subnet=10.0.1.0/24
   + Connect containers to user-defined "front_net" network
    
    $ docker network connect front_net post
    
    $ docker network connect front_net comment
  + Ensure that [Monolith Reddit](http://35.195.87.92:9292/) up and running
  + Prepared for .env file with user-defined variables in docker-compose.yml file
  + Prepared docker-compose.override.yml file that aoutomatically roll-out within docker-compose.yml file:
  
    $ docker-compose up -d
  + Ensure that all containers are implemented by using docker-compose ps:
  
  ```docker-compose ps
  Name                  Command             State           Ports         
----------------------------------------------------------------------------
src_comment_1   puma --debug -w 2             Up                            
src_post_1      python3 post_app.py           Up                            
src_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp             
src_ui_1        puma --debug -w 2             Up      0.0.0.0:9292->9292/tcp
 ```
  + All docker-compose entity have project related pefix (at this point is "src_") which is the name of current project directory.
_______________________________________________________________________________________________
  ## 5. Gitlab: Deployment & pipeline preparations
  ### Main issue: Docker-based Gitlab deployment on GCP instance, pipeline implementation
  ### Additional task: Design and implement scalable solution for Gitlab Runner in one configuration file & Chat Ops implement
  ## System prerequisites:
  + Prepare new instance using [gist](https://gist.githubusercontent.com/SergeyKa-cmd/b761cb0f4c1c9cb363600a177eebfb26/raw/7490234f952cad68a0df1756013ace6efb56f103/gistfile1.txt) from scrach and run it from terminal
  + Connect to current running GCE instance using command:
  
    $ eval $(docker-machine env docker-host)
    
    $ docker-machine ssh docker-host
  + Prepare docker environment on instance using snippet:
  ```# mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
     # cd /srv/gitlab/
     # touch docker-compose.yml
  ```
  + Fill out docker.compose.yml file on docker-host instance using this [gist](https://gist.github.com/Nklya/c2ca40a128758e2dc2244beb09caebe1) and run:
  
    $ docker-compose up -d
  + Ensure that GCP instance up and running with Gitlab web interface http://<your-vm-ip>
  
  ## App testing:
  + Clone current repository to your environment
  + Ensure that GCP instance up and running with Gitlab web interface http://<your-vm-ip>
  + Using SSH to docker-host run this [gist](https://gist.githubusercontent.com/SergeyKa-cmd/bc4035b974b0e07b62397dab2ad1bd2a/raw/7e422223e5fcaf82b389f6a856e1eadf70c64c04/Gitlab%2520Runner%2520registration) in terminal for Runner registration
  + Second step to register Gitlab Runner interactively in terminal:
  
  ```root@gitlab-ci:~# docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false
     Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
      http://<YOUR-VM-IP>/
      Please enter the gitlab-ci token for this runner:
      <TOKEN>
      Please enter the gitlab-ci description for this runner:
      [38689f5588fe]: my-runner
      Please enter the gitlab-ci tags for this runner (comma separated):
      linux,xenial,ubuntu,docker
      Please enter the executor:
      docker
      Please enter the default Docker image (e.g. ruby:2.1):
      alpine:latest
      Runner registered successfully.
  ```    
  + All further manipulations were done in .gitlab-ci.yml file where added and described stages:
  ```stages:
    - build
    - test
    - review
    - stage
    - production
   ```
  ## Additional task tips:
   + For reddit app implementation used this [Automatically build and push Docker images using GitLab CI manual](https://angristan.xyz/build-push-docker-images-gitlab-ci/) where decribed how to use DockerHub credentials in Gitlab:
   ![Alt text](/home/sergeyka/Desktop/variables.png?raw=true "Title")
   + Placed code to .gitlab-ci.yml file in build stage section
   + Gitlab Runner configuration uses the .toml file [Gitlab Documentation](https://docs.gitlab.com/runner/configuration/advanced-configuration.html) for multitasking 
   + For automation deployment of numerous Gitlab Ci Runner we're used config.toml.example file (config.toml was excluded with .gitignore due to secret information) related to this [Manual](https://habr.com/en/post/449910/)
   + For Chat Ops implementation (Gitlab+Slack) we're used this [Simple manual](https://docs.gitlab.com/ee/user/project/integrations/slack.html)
   ___________________________________________________________________________________________________________________
   ## 6. Monitoring: Prometheus configuring and deployment
  ### Main issue: Deployment Prometheus and monitoring implementation for Reddit microservices
  ### Additional task:  Using custom exporters for metrics capturing & Prepare Makefile for services automation deployment
  ## System prerequisites:
  + Prepare firewall rules in GCE using terminal on local host:
  
    $ gcloud compute firewall-rules create prometheus-default --allow tcp:9090
    
    $ gcloud compute firewall-rules create puma-default --allow tcp:9292
  + Use current running GCE instance using command:
  
    $ eval $(docker-machine env docker-host)
    
    $ docker-machine ssh docker-host
  ## App testing:
  + Clone current repository to your environment
  + Fetch docker images from current GitHub repository using ```make``` command in your terminal
  + Ensure that GCP instance with Prometheus up and running on http://your-vm-ip:9090
  ## Additional task tips:
   + For preparing Makefile use this [tutorial](http://rus-linux.net/nlib.php?name=/MyLDP/algol/gnu_make/gnu_make_3-79_russian_manual.html#SEC33)
   + Information regarding how to use [Google Cloudprober](https://hub.docker.com/r/cloudprober/cloudprober)
   + [Bitnami MongoDB exporter on DockerHub](https://hub.docker.com/r/bitnami/mongodb-exporter)
   __________________________________________________________________________________________________________________________
   ## 7. Monitoring: Monitoring system deployment & Alerting
  ### Main issue: Monitoring systems implement: cAdvisor, Grafana in depth, Alerting to Slack
  ### Additional task: Grafana dashboards customization, Telegraf implemetation, alerting to external e-mail
  ## System prerequisites:
  + Prepare firewall rules in GCE using terminal on local host for following ports:
  
    $ gcloud compute firewall-rules create prometheus-default --allow tcp:9090
    
    $ gcloud compute firewall-rules create post-default --allow tcp:5000
    
    $ gcloud compute firewall-rules create grafana-default --allow tcp:3000
    
    $ gcloud compute firewall-rules create cadvisor-default --allow tcp:8080
  + Connect to current running GCE instance using command:
  
    $ eval $(docker-machine env docker-host)
    
    $ docker-machine ssh docker-host
  ## App testing:
  + Clone current repository to your environment
  + Fetch docker images from current GitHub repository using ```make``` command in your terminal
  + Ensure that GCP instance with installed microservices up and running on:
  
    http://docker-host:9292
  
    http://docker-host:3000
    
    http://docker-host:9090
    
    http://docker-host:8080
  + Current docker-host is: 35.205.143.175
__________________________________________________________________________________________________________________________
  ## 8. Logging: Logging and distributed tracing systems
 ### Main issue: ELK and Zipkin tracing systems implementation and tuning
 ### Additional task: Tuning distributed logs configuration in fluentd.conf file + fixing Reddit app using Zipkin tracing
   ## App testing:
  + Clone current repository to your environment
  + Fetch docker images from current GitHub repository using ```make``` command in your terminal
  + Ensure that GCP instance with installed microservices up and running on:
  
    http://localhost:9292 -> Reddit App
    
    http://localhost:5601 -> Kibana logging App
    
    http://localhost:9411 -> Zipkin tracing App
    
    Current localhost address is: http://35.223.25.123
     ## ELK installing known issues:
    + After docker-compose command Kibana web app shows ```Kibana service is not ready yet``` means incufficient instance resources and recommended to use [solution](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html):
     ```environment:
      - node.name=es01
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
      ```
     ### Additional task tips:
     + Before error correction Reddit web app have errors on comment service:
   ![alt text](https://c.radikal.ru/c41/1912/74/ab7f0da3736e.png)
     + For fixing [Buggy-code](https://github.com/Artemmkin/bugged-code) from Express42 need to correct Docker file in ```troublesrc/buggy-code/comment``` with proper link to comment_db service
     + Also need to correct ```# Schedule health check function``` section in comment_app.rb file
   ___________________________________________________________________________________________________________________________
   ### 9. Kubernetes: First look & Automated deployment implementation
  ### Main issue: "Kubernetes-the-hard-way" deployment by KesleyHightower
  ### Additional task: Automated deployment with Kubernetes+Ansible
  #### System prerequisites:
  + All 13 steps described in [Guide](https://github.com/kelseyhightower/kubernetes-the-hard-way)
  #### App testing:
  + Clone current repository to your environment
  + Automated deploy used from [pyaillet](https://github.com/Zenika/k8s-on-gce) :
  
    + Prepare Google API credentials from current project, name as adc.json and put in the app dir
    + Adapt profile file to match your desired region, zone and project
    + Launch ./in.sh, it will build a docker image and launch a container with all needed tools
    + In the container, launch ./create.sh and wait for ~10mins ```
  + This deployment procedure involves creating Docker machine, with instances deployment using Terraform and finally play Ansible books to instances
_______________________________________________________________________________________________________________________________
  ### 10. Kubernetes: Running microservices on Kubernetes cluster & GKE deployment
  ### Main issue: Cluster prototyping with Minikube & Google Kubernetes Environment deployment
  ### Additional task: GKE deployment with Terraform
  #### System prerequisites:
  + Install current version of [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux)
  + Install local hypervisor, simply is Virtualbox
  + Install [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) for local prototyping kubernetes clustering
  + Preform initial setup for [GKE](https://console.cloud.google.com/kubernetes)
  + For access to Kubernetes UI dashboard use [tutorial for AWS](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html) (It's working for GKE too)
  #### App testing:
  + Clone current repository and run with Terraform environment from ./kubernetes/k8s-on-gce:
      
      $ terraform init
      
      $ terraform plan
      
      $ terraform apply
  + Find out IP and port or current running Reddit-app by commandlets:
      
      $ kubectl get nodes -o wide
      
      $ kubectl describe service ui -n dev | grep NodePort
  + Ensure that Microservices up and running on http://35.195.192.255:32092/
  + Run $ kubectl proxy on terminal and try to open [Kubernetes Dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)
  + Kubernetes Dashboard asks for token which you can use described in [tutorial for AWS](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html)
  ![alt text](https://b.radikal.ru/b01/1912/b9/95ac09960351.png)
______________________________________________________________________________________________________________________________
  ### 11. Kubernetes: Endpoint communications & Data storing policy
  ### Main issue: Understanding of endpoints networking and PersistentVolumeClaim implement
  ### Additional task: TLS implement with YAML manifest
  #### System prerequisites:
   + Clone current repository and deploy sevices for interconnection between them
   + Switch to DEV namespace using:
    
     $ kubectl apply -f ./kubernetes/reddit/dev-namespace.yml
   + Deploy all components running manifests:
   
     $ kubectl apply -f ./kubernetes/reddit/ -n dev
   + Get current address of ingress controller by cmdlet:
    
     $ kubectl get ingress -n dev
   + For using TLS connection to Reddit-app create ```tls.key``` and ```tls.crt``` using ingress IP as CN in openssl:
     
     $ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=ingress_IP"
   + Push this files to Kubernetes cluster:
   
     $ kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev
          Perform my-secret.yml file with tls.key and tls.crt keys
  #### App testing:
   + Check up and running Reddit-app on https://35.244.170.122/
   + Check out that PersistentVolume disks are created correctly:
   
   ![alt text](https://c.radikal.ru/c39/1912/0a/a63bcfdc2c5f.png)
 #### Additional task tips:
   + For preparing ```my-secret.yml``` manifest check [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
_____________________________________________________________________________________________________________________________
      
