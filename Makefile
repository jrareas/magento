# Defaults settings (when building locally)
SHELL := /bin/sh

GCP_REGISTRY=us.gcr.io/minhamaedizia
IMAGE_NAME=$(GCP_REGISTRY)/magento_magento

-include variables.sh

variables.sh: ##
	unzip -o -P $(ZIP_SECRET) variables.zip

help:	 ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fg

build:   ## build the image
	docker build \
		--build-arg MAGENTO_DB_HOST=$(MAGENTO_DB_HOST) \
		--build-arg MAGENTO_DB_NAME=$(MAGENTO_DB_NAME) \
		--build-arg MAGENTO_DB_USER=$(MAGENTO_DB_USER) \
		--build-arg MAGENTO_DB_PASS=$(MAGENTO_DB_PASS) \
		-t $(IMAGE_NAME) .

push:    ## push the image to the docker registry
	docker push $(IMAGE_NAME)

tag: ## Tag the built image with the tag name (make tag TAG_VER=xxx)
	docker tag $(IMAGE_NAME) $(IMAGE_NAME)

pull:    ## pull an image from the docker registry
	docker pull $(IMAGE_NAME)
