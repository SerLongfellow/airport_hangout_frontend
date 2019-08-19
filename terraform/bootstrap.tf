
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "com.jefflong.airporthangout"
    key    = "infrastructure/terraform-state.tfstate"
    region = "us-east-1"
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "airport-hangout-ecr-repo"
}
