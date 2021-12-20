SHELL := /usr/bin/env bash

GOOGLE_APPLICATION_CREDENTIALS := $(PWD)/secrets/$(KEY_FILE)

define TF_VARS
-var="project_id=$(PROJECT_ID)"
endef

# Run checkov.
.PHONY: checkov
checkov:
	checkov --directory . \

# Run checkov on the plan.
.PHONY: checkov_plan
checkov_plan:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform plan -out=tf.plan $(TF_VARS); \
	terraform show -json tf.plan | jq '.' > tf.json; \
	checkov --file tf.json --skip-framework cloudformation; \
	rm tf.json

# Destroy all remote objects.
.PHONY: go_test
go_test:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	export PROJECT_ID=$(PROJECT_ID); \
	cd test; \
	go test -v

# Initialize the workspace.
.PHONY: tf_init
tf_init:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform init -backend-config="bucket=$(PROJECT_ID)-tfstate"

# Validate the configuration files.
.PHONY: tf_validate
tf_validate:
	cd terraform; \
	terraform validate

# Check the providers.
.PHONY: tf_providers
tf_providers:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform providers

# Check the outputs.
.PHONY: tf_output
tf_output:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform output

# Refresh state.
.PHONY: tf_refresh
tf_refresh:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform refresh $(TF_VARS)

# Create an execution plan
.PHONY: tf_plan
tf_plan:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform plan -out=tf.plan $(TF_VARS)

# Execute the plan
.PHONY: tf_apply
tf_apply:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform apply tf.plan; \
	rm tf.plan

# Destroy all remote objects
.PHONY: tf_destroy
tf_destroy:
	export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS); \
	cd terraform; \
	terraform destroy -auto-approve $(TF_VARS)