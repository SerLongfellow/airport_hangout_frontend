
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "com.jefflong.airporthangout.ops"
    key    = "frontend/infrastructure/bootstrap-terraform-state.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket_prefix = "com.jefflong.airporthangout.frontend."
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "airport_hangout_ecr_repo"
}

resource "aws_iam_role" "codebuild_role" {
  name = "airport_hangout_codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = "${aws_iam_role.codebuild_role.name}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "${aws_ecr_repository.ecr_repo.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": ["${aws_s3_bucket.frontend_bucket.arn}", "${aws_s3_bucket.frontend_bucket.arn}/*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_codebuild_project" "codebuild" {
  name          = "airport_hangout_frontend_codebuild"
  description   = ""
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild_role.arn}"
  badge_enabled = true

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "LOCAL"
    modes    = ["LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name = "airport_hangout_frontend/builds"
      stream_name = "codebuild"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/SerLongfellow/airport_hangout_frontend.git"
    git_clone_depth = 1
    report_build_status = true
    auth {
      type = "OAUTH"
      resource = "arn:aws:codebuild:us-east-1:394069212708:token/github"
    }
  }
}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  project_name = "${aws_codebuild_project.codebuild.name}"
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PUSH"
    }
  }
  
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PULL_REQUEST_CREATED,PULL_REQUEST_UPDATED,PULL_REQUEST_REOPENED,PULL_REQUEST_MERGED"
    }
  }
}
