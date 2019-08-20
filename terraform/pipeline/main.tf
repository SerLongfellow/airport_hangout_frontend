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
  role = aws_iam_role.codebuild_role.name

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
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
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
  service_role  = aws_iam_role.codebuild_role.arn
  badge_enabled = true

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
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
      group_name  = "airport_hangout_frontend/builds"
      stream_name = "codebuild"
    }
  }

  source {
    type                = "GITHUB"
    location            = "https://github.com/SerLongfellow/airport_hangout_frontend.git"
    git_clone_depth     = 1
    report_build_status = true
    auth {
      type     = "OAUTH"
      resource = "arn:aws:codebuild:us-east-1:394069212708:token/github"
    }
  }
}

resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "ECS"
  name             = "airport_hangout_frontend_app"
}

resource "aws_codedeploy_deployment_config" "codedeploy_config" {
  deployment_config_name = "airport_hangout_frontend_app_deploy_config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "com.jefflong.pipelines"
  acl           = "private"
  force_destroy = true
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  name      = "airport_hangout_frontend_pipeline"
  role_arn  = "${aws_iam_role.codepipeline_role.arn}"
  
  artifact_store {
    location = "${aws_s3_bucket.codepipeline_bucket.bucket}"
    type     = "S3"
  }

  stage {
    name        = "Source"
    
    action {
      name        = "Source"
      category    = "Source"
      owner       = "ThirdParty"
      provider    = "GitHub"
      version     = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Owner  = "SerLongfellow"
        Repo   = "airport_hangout_frontend"
        Branch = "feature/ci"
        PollForSourceChanges = "false"
      }
    }
  }
  
  stage {
    name        = "Build"
    
    action {
      name        = "Build"
      category    = "Build"
      owner       = "AWS"
      provider    = "CodeBuild"
      version     = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = "airport_hangout_frontend"
      }
    }
  }
}

/*
resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name = "airport_hangout_frontend_codepipeline_github_webhook"
  target_pipeline = "${aws_codepipeline.codepipeline.name}"
  target_action   = "Source"

  authentication = "GITHUB_HMAC"
  authentication_configuration {
    secret_token = "${var.webhook_secret}"
  }
   
  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}*/
