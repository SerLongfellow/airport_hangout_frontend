
resource "aws_iam_role" "codebuild_infra_role" {
  name = "airport_hangout_codebuild_infra_role"

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

resource "aws_iam_role_policy" "codebuild_infra_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*"
            ],
            "Resource": ["${aws_s3_bucket.codepipeline_bucket.arn}", "${aws_s3_bucket.codepipeline_bucket.arn}/*"]
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

resource "aws_codebuild_project" "codebuild_infra" {
  name          = "airport_hangout_frontend_codebuild_infra"
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
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "airport_hangout_frontend/builds"
      stream_name = "infrastructure"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec_infrastructure.yml"
  }
}