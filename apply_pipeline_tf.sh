#!/bin/bash

terraform apply -var="webhook_secret=$(cat ~/secrets/github-webhook-secrets)" terraform/pipeline
