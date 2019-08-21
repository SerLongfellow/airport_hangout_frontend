
resource "aws_iam_role" "codebuild_bootstrap_role" {
  name = "airport_hangout_codebuild_bootstrap_role"

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

resource "aws_iam_role_policy" "codebuild_bootstrap_policy" {
  role = "${aws_iam_role.codebuild_bootstrap_role.name}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:Put*",
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
                "s3:Get*",
                "s3:Put*",
                "s3:List*"
            ],
            "Resource": ["${var.ops_bucket}", "${var.ops_bucket}/*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codepipeline:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY

}

resource "aws_codebuild_project" "codebuild_bootstrap" {
  name          = "airport_hangout_frontend_codebuild_bootstrap"
  description   = ""
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild_bootstrap_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "NO_CACHE"
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
      stream_name = "bootstrap"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec_bootstrap.yml"
  }
}
