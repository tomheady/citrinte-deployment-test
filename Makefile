AWS_PROFILE := citrine-interview-admin

# note that this is created with "terraform apply" and will change with different accounts
ECR_REPOSITORY = 624081292306.dkr.ecr.us-west-2.amazonaws.com/punch/sample-service

SHELL := /bin/bash
GIT_REPOSITORY := git@github.com:CitrineInformatics/sample-service.git
GIT_HASH := master
APP_NAME := sample-service

BIN_GIT := $(or $(shell which git),git_missing)
BIN_DOCKER := $(or $(shell which docker),docker_missing)
BIN_DOCKER_CREDENTIAL_PASS := $(or $(shell which docker-credential-pass),docker_credential_pass_missing)
BIN_TERRAFORM := $(or $(shell which terraform),terraform_missing)

.PHONY: all check_local clone build docker_tag docker_push terraform_init terraform_validate terraform_plan terraform_apply terraform_destroy aws_check_error aws_decode aws

all:
	@echo nothing here yet

check_local: $(BIN_GIT) $(BIN_DOCKER) $(BIN_DOCKER_CREDENTIAL_PASS) $(BIN_TERRAFORM) $(BIN_AWS)
	@echo looks good

clone: $(APP_NAME)

$(APP_NAME): $(BIN_GIT)
	git clone $(GIT_REPOSITORY) sample-service

build: $(BIN_GIT) $(BIN_DOCKER)
	cd $(APP_NAME) && git pull && git checkout $(GIT_HASH)
	docker build -t $(APP_NAME) $(APP_NAME)

docker_tag: $(BIN_DOCKER)
	docker tag $(APP_NAME) $(ECR_REPOSITORY):latest

docker_push: $(BIN_DOCKER)
	docker push ${ECR_REPOSITORY}:latest

# TODO at setup: connect your docker to the elastic container registry punch/sample-service
# aws ecr get-login-password --region us-west-2 --profile citrine-interview-admin | docker login --username AWS --password-stdin 624081292306.dkr.ecr.us-west-2.amazonaws.com/punch/sample-service

terraform_init: $(BIN_TERRAFORM)
	terraform -chdir=citrine-sample-service-terraform init

terraform_validate: $(BIN_TERRAFORM)
	terraform -chdir=citrine-sample-service-terraform validate

terraform_plan: $(BIN_TERRAFORM)
	terraform -chdir=citrine-sample-service-terraform plan

terraform_apply: $(BIN_TERRAFORM)
	terraform -chdir=citrine-sample-service-terraform apply -auto-approve

terraform_destroy: $(BIN_TERRAFORM)
	terraform -chdir=citrine-sample-service-terraform destroy


# If you are using a minimal permissions model, your terraform apply will return errors
# until you get all the permissions added.  aws_check_error and aws_decode will help you get the
# permissions you are missing when errors happen.

# examples:
# make aws_check_error REQ=93d9650a-3595-48ca-9447-b9dedc99592d
# make aws_check_error REQ=
# 
# note that cloudtrail events can take up to 15 minutes to be displayed here
#
# FIXME: right now this queries cloudtrail for everything in the last hour
# we want it to only get errors or even better would be a specific event

aws_check_error: $(BIN_AWS)
	echo "Time,Service,Action,Error,Message"; \
  	aws cloudtrail lookup-events --profile $(AWS_PROFILE) --start-time $(shell date -d "-60 minutes" +%s) \
		--query "Events[*].CloudTrailEvent" --output text | jq -r ". | select(.requestID == \"$(REQ)\") \
    | [.eventTime, .eventSource, .eventName, .errorCode, .errorMessage]"

# make aws_decode MSG=
aws_decode: $(BIN_AWS)
	aws --profile $(AWS_PROFILE) sts decode-authorization-message \
	  --encoded-message \"$(MSG)\" --query DecodedMessage --output text | jq '.'

# this is required if your account does not have the AWSServiceRoleForECS.
# this can happen if your account is old.
# aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com --profile citrine-interview-admin

$(BIN_GIT):
	@ echo "git not found.";
	@ echo "sudo apt-get install git";
	@ exit 1;

$(BIN_DOCKER):
	@ echo "docker not found.";
	@ echo "https://docs.docker.com/get-docker/";
	@ exit 1;

$(BIN_DOCKER_CREDENTIAL_PASS):
	@ echo "docker-credential-pass not found.";
	@ echo "https://www.techrepublic.com/article/how-to-setup-secure-credential-storage-for-docker/";
	@ exit 1;

$(BIN_TERRAFORM):
	@ echo "terraform not found.";
	@ echo "https://www.terraform.io/downloads.html";
	@ exit 1;

aws: $(BIN_AWS) ~/.aws/config ~/.aws/credentials

$(BIN_AWS):
	@ echo "aws not found. apt-get install awscli";
	@ exit 1;

~/.aws/config:
	@ echo "!! missing ~/.aws/config file !! (restore from backup?)";
	@ exit 1;

~/.aws/credentials:
	@ echo "!! missing ~/.aws/credentials file !! (restore from backup?)";
	@ exit 1;
