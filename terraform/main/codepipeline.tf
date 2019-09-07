
module "resources" {
  source = "./resources"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"

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
        "${module.resources.codepipeline_bucket_output.arn}",
        "${module.resources.codepipeline_bucket_output.arn}/*"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.ops_bucket}",
        "${var.ops_bucket}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:*"
      ],
      "Resource": "*"
    },
    {
      "Action": [
        "ecs:*",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:ModifyRule",
        "lambda:InvokeFunction",
        "cloudwatch:DescribeAlarms",
        "sns:Publish",
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "iam:PassedToService": [
            "ecs-tasks.amazonaws.com"
          ]
        }
      }
    }
  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  name      = "airport_hangout_frontend_pipeline"
  role_arn  = "${aws_iam_role.codepipeline_role.arn}"
  
  artifact_store {
    location = "${module.resources.codepipeline_bucket_output.bucket}"
    type     = "S3"
  }

  stage {
    name        = "Source"
    
    action {
      name        = "Source"
      category    = "Source"
      owner       = "AWS"
      provider    = "S3"
      version     = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        S3Bucket    = "${var.ops_bucket_name}"
        S3ObjectKey = "airport_hangout_frontend/airport_hangout_frontend_source.zip"
      }
    }
  }
  
  stage {
    name = "Build"
    
    action {
      name        = "Build"
      category    = "Build"
      owner       = "AWS"
      provider    = "CodeBuild"
      version     = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild.name}"
      }
    }
  }
  
  stage {
    name = "Deploy"
    
    action {
      name        = "Deploy"
      category    = "Deploy"
      owner       = "AWS"
      provider    = "ECS"
      version     = "1"
      input_artifacts = ["BuildArtifact"]
      output_artifacts = []

      configuration = {
        ClusterName="airport_hangout_frontend_cluster"
        ServiceName="airport_hangout_frontend_service"
        FileName="imagedefinitions.json"
      }
    }
  }
}
