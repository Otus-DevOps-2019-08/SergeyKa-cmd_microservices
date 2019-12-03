#Define variables
BUILD_ALL = build_ui build_comment build_post build_prometheus
PUSH_TO = push_ui push_comment push_post push_prometheus
MANAGE_DOCKER_C = docker_c_up docker_c_down
USER_NAME = sergeykacmd #DockerHub account
#Abstract target BUILD_ALL
.PHONY: BUILD_ALL
build_ui:
	cd src/ui && bash docker_build.sh
build_comment:
	cd src/comment && bash docker_build.sh
build_post:
	cd src/post-py && bash docker_build.sh
build_prometheus:
	cd monitoring/prometheus && docker build -t ${USER_NAME}/prometheus .
#Abstract target PUSH_TO_DOCKER_HUB
.PHONY: PUSH_TO
push_ui:
	docker push ${USER_NAME}/ui
push_comment:
	docker push ${USER_NAME}/comment
push_post:
	docker push ${USER_NAME}/post
push_prometheus:
	docker push ${USER_NAME}/prometheus
#Abstract target MANAGE_DOCKER_COMPOSE
.PHONY: MANAGE_DOCKER_C
docker_c_up:
	cd docker/ && docker-compose up -d
docker_c_down:
	cd docker/ && docker-compose down
