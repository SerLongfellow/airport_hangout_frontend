provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

variable "webhook_secret" {
  type        = string
  description = "Secret to integrate GitHub webhook into CodePipeline"
}

variable "github_token" {
  type        = string
  description = "Token to use GitHub API from CodePipeline"
}

variable "ops_bucket" {
  type        = string
  description = "Name of bucket used for terraform state storage - needed to provision CodeBuild infrastructure job permissions"
  default     = "arn:aws:s3:::com.jefflong.airporthangout.ops"
}

terraform {
  backend "s3" {
    bucket = "com.jefflong.airporthangout.ops"
    key    = "frontend/infrastructure/bootstrap-terraform-state.tfstate"
    region = "us-east-1"
  }
}

