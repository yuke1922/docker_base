IMG_NAME=yuke1922/docker-ansible-netbox
IMG_VERSION=v1
CONTAINER_NAME=netbox-runner
.DEFAULT_GOAL := cli

.PHONY: build
build:
	docker build -t $(IMG_NAME):$(IMG_VERSION) . 

.PHONY: cli
cli:
	docker run -it --rm --name ${CONTAINER_NAME}\
		-v $(shell pwd):/local \
		-w /local \
		$(IMG_NAME):$(IMG_VERSION) bash

.PHONY: run
run:
	docker run -it --rm --name ${CONTAINER_NAME}\
		-v $(shell pwd):/local \
		-w /local \
		$(IMG_NAME):$(IMG_VERSION) ansible-playbook playbooks/00-main.yml

.PHONY: verbose
verbose:
	docker run -it --rm --name ${CONTAINER_NAME}\
		-v $(shell pwd):/local \
		-w /local \
		$(IMG_NAME):$(IMG_VERSION) ansible-playbook playbooks/00-main.yml -i inventory.yml -vvvvvvv


.PHONY: purge
purge:
	docker container prune -f
	docker image prune -f -a
	docker volume prune -f
	docker builder prune -f -a

.PHONY: clean
clean:
	docker container prune -f



.PHONY: inventory
inventory:
	docker run -it --rm --name ${CONTAINER_NAME}\
		-v $(shell pwd):/local \
		-w /local \
		$(IMG_NAME):$(IMG_VERSION) ansible-inventory -i inventory.yml --list

.PHONY: vars
vars:
	docker run -it --rm --name ${CONTAINER_NAME}\
		-v $(shell pwd):/local \
		-w /local \
		$(IMG_NAME):$(IMG_VERSION) ansible-playbook -i inventory.yml tests/99-get-vars.yml --ask-vault-pass

.PHONY: cables
cables:
	docker run -it --rm --name ${CONTAINER_NAME}\
		-v $(shell pwd):/local \
		-w /local \
		$(IMG_NAME):$(IMG_VERSION) ansible-playbook -i inventory.yml playbooks/501-cables.yml
