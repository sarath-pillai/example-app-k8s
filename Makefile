APP_NAME       := "tree"
IMAGE_TAG      := $(shell git rev-parse --short HEAD)
REPO_NAME      := "sarathpillai88/tree"

build :
	echo "Building Docker Image for  Tree app...";
	echo "Image Tag would be $(IMAGE_TAG)";
	docker build -t $(REPO_NAME):$(IMAGE_TAG) .;

test :
	echo "Running Test Cases...";
	docker run --rm -v $(PWD):/opt/  python:2.7.12 /bin/sh -c "pip install -r /opt/requirements.txt && python -m pytest /opt/test_server.py && rm -rf /opt/__pycache__";

publish:
	echo "Pushing Image to Registry..";
	docker push $(REPO_NAME):$(IMAGE_TAG)

deploy:
	echo "Deploying Using Helm"
	$(eval PKG=$(shell sh -c "helm package --app-version=$(IMAGE_TAG) helm | awk '{print $8}'"))
	helm upgrade --install $(APP_NAME)  --set image.tag=$(IMAGE_TAG) tree-0.1.0.tgz

all:
	echo "Running Test Cases...";
	docker run --rm -v $(PWD):/opt/  python:2.7.12 /bin/sh -c "pip install -r /opt/requirements.txt && python -m pytest /opt/test_server.py && rm -rf /opt/__pycache__";
	echo "Building Docker Image for  Tree app...";
	echo "Image Tag would be $(IMAGE_TAG)";
	docker build -t $(REPO_NAME):$(IMAGE_TAG) .;
	echo "Pushing Image to Registry..";
	docker push $(REPO_NAME):$(IMAGE_TAG)
	echo "Deploying Using Helm"
	$(eval PKG=$(shell sh -c "helm package --app-version=$(IMAGE_TAG) helm | awk '{print $8}'"))
	helm upgrade --install $(APP_NAME)  --set image.tag=$(IMAGE_TAG) --set image.repository=$(REPO_NAME) tree-0.1.0.tgz
