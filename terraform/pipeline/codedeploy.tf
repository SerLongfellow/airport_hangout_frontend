
resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "ECS"
  name             = "airport_hangout_frontend_app"
}

resource "aws_codedeploy_deployment_config" "codedeploy_config" {
  deployment_config_name = "airport_hangout_frontend_app_deploy_config"
  
  traffic_routing_config {
    type = "AllAtOnce"
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name = "airport_hangout_frontend_codedeploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codedeploy_policy" {
  name = "airport_hangout_frontend_codedeploy_policy"
  role = "${aws_iam_role.codeploy_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecs:DescribeServices",
                "ecs:CreateTaskSet",
                "ecs:UpdateServicePrimaryTaskSet",
                "ecs:DeleteTaskSet",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:ModifyRule",
                "lambda:InvokeFunction",
                "cloudwatch:DescribeAlarms",
                "sns:Publish",
                "s3:GetObject",
                "s3:GetObjectMetadata",
                "s3:GetObjectVersion"
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

resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  deployment_group_name = "airport_hangout_frontend_app_deploy_group"
  app_name              = "${aws_codedeploy_app.codedeploy_app.name}"
  service_role_arn      = "${aws_iam_role.codedeploy_role.arn}"

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }
  
  ecs_service {
    cluster_name = "airport_hangout_frontend_cluster"
    service_name = "airport_hangout_frontend_ecs_task"
  }
}
