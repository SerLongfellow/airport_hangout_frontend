#!/bin/bash

terraform init terraform/bootstrap
terraform apply -var="github_token=$(cat ~/secrets/github-token)" -var="webhook_secret=$(cat ~/secrets/github-webhook-secrets)" terraform/bootstrap
