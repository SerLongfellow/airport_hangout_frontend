
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "com.jefflong.airporthangout.ops"
    key    = "frontend/infrastructure/application-terraform-state.tfstate"
    region = "us-east-1"
  }
}

