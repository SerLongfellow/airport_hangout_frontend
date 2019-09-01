
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
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "${module.resources.codepipeline_bucket_output.arn}",
                "${module.resources.codepipeline_bucket_output.arn}/*"
            ]
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

  artifacts {
    type = "CODEPIPELINE"
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
      stream_name = "app"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec_application.yml"
  }
}
