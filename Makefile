#Define variables
GCP_INSTANCE = gcp_deployment
BUILD_ALL = build_ui build_comment build_post build_prometheus build_cloudprober build_grafana build-alertmanager build-telegraf
PUSH_TO = push_ui push_comment push_post push_prometheus push_cloudprober push_grafana push_alertmanager push_telegraf
UP_SERVICE = dc_up_app dc_up_monitoring
USER_NAME = sergeykacmd #DockerHub account
#Prepare google instance
.PHONY: gcp_deployment
gcp_deployment:
	docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-open-port 9090/tcp \
    --google-open-port 5000/tcp \
    --google-open-port 8080/tcp \
    --google-open-port 3000/tcp \
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
	cd monitoring/prometheus && docker build -t ${USER_NAME}/prometheus .
build_cloudprober:
	cd monitoring/cloudprober && docker build -t ${USER_NAME}/cloudprober .
build_grafana:
	cd monitoring/grafana && docker build -t ${USER_NAME}/grafana .
build_alertmanager:
	cd monitoring/alertmanager && docker build -t ${USER_NAME}/alertmanager .
build_telegraf:
	cd monitoring/telegraf && docker build -t ${USER_NAME}/telegraf .
#Pushing services to DockerHub
push_ui:
	docker push ${USER_NAME}/ui
push_comment:
	docker push ${USER_NAME}/comment
push_post:
	docker push ${USER_NAME}/post
push_prometheus:
	docker push ${USER_NAME}/prometheus
push_cloudprober:
	docker push ${USER_NAME}/cloudprober
push_grafana:
	docker push ${USER_NAME}/grafana
push_alertmanager:
	docker push ${USER_NAME}/alertmanager
push_telegraf:
	docker push ${USER_NAME}/telegraf
#Up services from yml files to docker-host	
dc_up_app:
	cd docker/ && docker-compose build && docker-compose up -d
dc_up_monitoring:
	cd docker/ && docker-compose -f docker-compose-monitoring.yml up -d
