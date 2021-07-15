# Description
This repository contains a simple python flask based web server, that just responds over a single path and host.  The repository also houses two different directories namely `k8s` and `helm`. Both are methods using which this example application can be deployed. 

## Prerequisite
To try and test the contents of this repository you will need the below.
- A local docker installation.
- kubectl
- kubernetes cluster access (to implement this, minikube was used)
- make
- helm (https://helm.sh/docs/intro/install/)

## Description
The repository contains a Makefile, which can be used to build, publish(push image to registry), test & deploy to kubernetes cluster.

There are two variables to notice inside Makefile.
1. IMAGE_TAG (tag of the image that will be created. By default it uses git commit hash short version)
2. REPO_NAME (The dockerhub repository name)

Ensure before running Make commands, that you have logged into docker hub/registry for the repository that you have specified inside Makefile.

In its current form, kubernetes objects assumes that the images are publicly available. However, the image can also be located in a private repository. But a private repository requires a proper authentication to be present. This can be achieved using `imagePullSecrets` (is available to toggle in helm/values.yaml) setting in kubernetes container definition. 

## How to Test, Build, Publish and Deploy this application
All of the above can be achieved using a single `make` command as shown below. 

```
make all
```
However, if you are just interested in executing test cases, that can be achieved using the below command. 
```
make test
```
Similarly just a docker build can be achieved using the below. 
```
make build
```
## How does the deployment work?
At its current form, the docker build generates a docker image in the form of REPO_NAME:TAG_NAME (tag name is the git commit hash). This image is then published to a docker registry(dockerhub is used as registry in this example). 

The make commands assumes that you have proper authentication to kubernetes cluster & Dockerhub registry.

The `helm` directory contains a simple `chart` named `tree` that deploys the application. It mainly has kubernetes objects like `deployment`, `service` & `ingress`.

The ingress class is by default set to Nginx. However, this can be easily modified using the helm/values.yaml file.  Helm permits you to override values during runtime (which is what `make deploy` step does). During the deploy step, we modify the Docker Image tag using `--set image.tag=$(IMAGE_TAG)`

## How was the helm directory generated?
Helm utility provides an easy method to create a helm chart to get started. Generating a skeleton helm chart is as simple as executing the below command. 

```
helm create helm
```
Altering `Chart.yaml` & `values.yaml`according to the application is easy to get started. 
Basically deploying an application onto kubernetes requires multiple kubernetes objects like `service`, `deployment`, `ingress`, `hpa` and such. All these necessary items for an app, is by default created using the helm chart (with facility to use just the objects that are needed. For example, HPA might not be needed in a non production environment.)

## What does the k8s directory do?
The k8s directory does the exact same thing that `helm` directory does. But `k8s` is more of raw kubernetes objects. The issue with using raw kuberenetes objects is the fact that overriding values like image tag etc during deployment is tricky.  One technique that can be used to do templating for raw kubernetes objects is `Kustomize`. https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/. 

## Any Other Methods?

- Rather than using a make file to test, build and deploy, these things can be achieved using a pipeline with different stages. For example, we can have a Jenkinsfile in this repository, that can contain stages for test, build and publish etc.  Each commit can be built and tested, depending on the pipeline stages. Jenkins can easily watch commits and pushes to the required branches to auto deploy (Similary, github workflows can also be used.)
- Apart from the methods demonstrated in this repository, we can also use terraform kubernetes provider (https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs), to create the kubernetes objects. Basically a terraform module can be created that creates an applicaion inside the cluster (the module will create resources like deployment objects, ingress, and services etc.)
