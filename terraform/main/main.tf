provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

variable "ops_bucket" {
  type        = string
  description = "Name of bucket used for terraform state storage - needed to provision CodeBuild infrastructure job permissions"
  default     = "arn:aws:s3:::com.jefflong.airporthangout.ops"
}

variable "ops_bucket_name" {
  type        = string
  description = "Name of bucket used for terraform state storage - needed to provision CodeBuild infrastructure job permissions"
  default     = "com.jefflong.airporthangout.ops"
}

terraform {
  backend "s3" {
    bucket = "com.jefflong.airporthangout.ops"
    key    = "frontend/infrastructure/main-terraform-state.tfstate"
    region = "us-east-1"
  }
}

