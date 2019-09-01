
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

  /*
  stage {
    name = "Provision"
    
    action {
      name        = "ProvisionAppInfrastructure"
      category    = "Build"
      owner       = "AWS"
      provider    = "CodeBuild"
      version     = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = []

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_infra.name}"
      }
    }
  }*/
  
  stage {
    name = "Deploy"
    
    action {
      name        = "DeployToTest"
      category    = "Deploy"
      owner       = "AWS"
      provider    = "CodeDeploy"
      version     = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = []

      configuration = {
        ApplicationName     = "${aws_codedeploy_app.codedeploy_app.name}"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.codedeploy_group.deployment_group_name}"
      }
    }
  }
}
