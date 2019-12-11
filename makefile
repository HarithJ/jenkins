# Project variables

.PHONY: help

## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '${YELLOW} make ${RESET} ${GREEN}<target> [options]${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		message = match(lastLine, /^## (.*)/); \
		if (message) { \
			command = substr($$1, 0, index($$1, ":")-1); \
			message = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} %s\n", command, message; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

# The default variables that would be used by all the targets except terraformApply.
# These variables would enable us to connect to the cluster and set the IP
# 	address for the loadbalancer.
ip=$(shell cd terraform && terraform output --module=gke ip-address)
gcpProjectId=$(shell cd terraform && terraform output --module=gke gcp-project-id)
clusterZone=$(shell cd terraform && terraform output --module=gke cluster-zone)
clusterName=$(shell cd terraform && terraform output --module=gke cluster-name)

## Make all the shell scripts used by this makefile executable
makeShellScriptsExec:
	@ chmod +x ./helm/helm.sh

# Set the variables to nothing as the cluster has not been created by Terraform
# 	and terraformApply is responsible for creating the cluster.
terraformApply: ip=""
terraformApply: gcpProjectId=""
terraformApply: clusterZone=""
terraformApply: clusterName=""

## Run terraform init and terraform apply
terraformApply:
	@ ${INFO} "Creating infrastructure using Terraform"
	@ cd terraform && terraform init && terraform apply

## Create infrastructure, install nginx-ingress and jenkins chart. Needs 3 key-value pairs: username=[username to login to Jenkins] password=[password to login to Jenkins] email=[admin email for jenkins setup]
apply: makeShellScriptsExec terraformApply
	@ ${INFO} "Connecting to cluster"
	@ ./helm/helm.sh connectToCluster $(clusterName) $(clusterZone) $(gcpProjectId)
	@ ${INFO} "Installing tiller on the cluster"
	@ ./helm/helm.sh helmIns
	@ ${INFO} "Installing Jenkins chart and Nginx-ingress chart"
	@ ./helm/helm.sh jenkinsIns $(ip) $(username) $(password) $(email)

## Destroy infrastructure via Terraform
destroy: makeShellScriptsExec
	@ ${INFO} "Destroying infrastructure using Terraform"
	@ cd terraform && terraform init && terraform destroy

## Get credentials for the cluster using gcloud
connectToCluster: makeShellScriptsExec
	@ ${INFO} "Connecting to cluster"
	@ ./helm/helm.sh connectToCluster $(clusterName) $(clusterZone) $(gcpProjectId)

## Install tiller on the cluster
tiller: makeShellScriptsExec
	@ ${INFO} "Installing tiller on the cluster"
	@ ./helm/helm.sh helmIns

## Install jenkins and nginx ingress chart. Needs 3 key-value pairs: username=[username to login to Jenkins] password=[password to login to Jenkins] email=[admin email for jenkins setup]
installCharts: makeShellScriptsExec
	@ ${INFO} "Installing Jenkins chart and Nginx-ingress chart"
	@ ./helm/helm.sh jenkinsIns $(ip)

## Upgrade Jenkins using helm upgrade command
upgradeJenkins: makeShellScriptsExec
	@ ${INFO} "Updating Jenkins chart"
	@ ./helm/helm.sh jenkinsUpgrade

## Delete Nginx ingress and Jenkins chart
deleteCharts: makeShellScriptsExec
	@ ${INFO} "Uninstalling Jenkins and Nginx-ingress Charts "
	@ ./helm/helm.sh jenkinsDel

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
MAGENTA  := $(shell tput -Txterm setaf 5)
NC := "\e[0m"
RESET  := $(shell tput -Txterm sgr0)
# Shell Functions
INFO := @bash -c 'printf $(YELLOW); echo "===> $$1"; printf $(NC)' SOME_VALUE
EXTRA := @bash -c 'printf "\n"; printf $(MAGENTA); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE
SUCCESS := @bash -c 'printf $(GREEN); echo "===> $$1"; printf $(NC)' SOME_VALUE
