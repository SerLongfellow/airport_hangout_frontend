provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

variable "webhook_secret" {
  type        = string
  description = "Secret to integrate GitHub webhook into CodePipeline"
}

terraform {
  backend "s3" {
    bucket = "com.jefflong.airporthangout.ops"
    key    = "frontend/infrastructure/bootstrap-terraform-state.tfstate"
    region = "us-east-1"
  }
}

