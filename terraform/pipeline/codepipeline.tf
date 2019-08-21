
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
        ProjectName = "${aws_codebuild_project.codebuild.name}"
        PrimarySource = "buildspec_application.yml"
      }
    }
    
    action {
      name        = "ProvisionAppInfrastructure"
      category    = "Build"
      owner       = "AWS"
      provider    = "CodeBuild"
      version     = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = []

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild.name}"
        PrimarySource = "buildspec_infrastructure.yml"
      }
    }
  }
}

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
}
