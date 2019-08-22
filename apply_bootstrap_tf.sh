#!/bin/bash

terraform init terraform/bootstrap
terraform apply terraform/bootstrap

aws codepipeline register-webhook-with-third-party --webhook-name airport_hangout_frontend_codepipeline_bootstrap_github_webhook 
