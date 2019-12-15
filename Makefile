#Define variables
GCP_INSTANCE = gcp_deployment
BUILD_ALL = build_ui build_comment build_post build_prometheus build_cloudprober build_grafana build-alertmanager build-telegraf
UP_SERVICE = dc_up_app dc_up_logging
USER_NAME = sergeykacmd #DockerHub account
#Prepare google instance
.PHONY: gcp_deployment
gcp_deployment:
	docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-open-port 9200/tcp \
    --google-open-port 24224/tcp \
    --google-open-port 5601/tcp \
    --google-open-port 9411/tcp \
    --google-address static-ip \
    --google-zone europe-west1-b \
	docker-host 
	echo 'Run - eval $$(docker-machine env docker-host)'
#Build services
build_ui:
	cd src/ui && bash docker_build.sh
build_comment:
	cd src/comment && bash docker_build.sh
build_post:
	cd src/post-py && bash docker_build.sh
build_prometheus:
	cd logging/fluentd && docker build -t ${USER_NAME}/fluentd .
#Up services from yml files to docker-host	
dc_up_logging:
	cd docker/ && docker-compose -f docker-compose-logging.yml up -d
dc_up_app:
	cd docker/ && docker-compose build && docker-compose up -d
