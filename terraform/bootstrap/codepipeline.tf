
resource "aws_iam_role" "codepipeline_bootstrap_role" {
  name = "codepipeline_bootstrap_role"

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

resource "aws_iam_role_policy" "codepipeline_bootstrap_policy" {
  name = "codepipeline_bootstrap_policy"
  role = "${aws_iam_role.codepipeline_bootstrap_role.id}"

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

resource "aws_codepipeline" "codepipeline_bootstrap" {
  name      = "airport_hangout_frontend_pipeline_bootstrap"
  role_arn  = "${aws_iam_role.codepipeline_bootstrap_role.arn}"
  
  artifact_store {
    location = "${var.ops_bucket_name}"
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
        Owner                = "SerLongfellow"
        Repo                 = "airport_hangout_frontend"
        Branch               = "feature/ci"
        PollForSourceChanges = "false"
        OAuthToken           = "${data.aws_kms_secrets.secrets.plaintext["github_token"]}"
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
        ProjectName = "${aws_codebuild_project.codebuild_bootstrap.name}"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "codepipeline_bootstrap_webhook" {
  name = "airport_hangout_frontend_codepipeline_bootstrap_github_webhook"
  target_pipeline = "${aws_codepipeline.codepipeline_bootstrap.name}"
  target_action   = "Source"

  authentication = "GITHUB_HMAC"
  authentication_configuration {
    secret_token = "${data.aws_kms_secrets.secrets.plaintext["webhook_secret"]}"
  }
   
  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}
