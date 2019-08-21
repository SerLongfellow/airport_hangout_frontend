#!/bin/bash

terraform apply -var="github_token=$(cat ~/secrets/github-token)" -var="webhook_secret=$(cat ~/secrets/github-webhook-secrets)" terraform/pipeline
