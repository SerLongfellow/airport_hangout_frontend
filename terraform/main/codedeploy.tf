
resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "ECS"
  name             = "airport_hangout_frontend_app"
}

resource "aws_codedeploy_deployment_config" "codedeploy_config" {
  deployment_config_name = "airport_hangout_frontend_app_deploy_config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
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
  role = "${aws_iam_role.codedeploy_role.id}"

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

resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  deployment_group_name  = "airport_hangout_frontend_app_deploy_group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  app_name               = "${aws_codedeploy_app.codedeploy_app.name}"
  service_role_arn       = "${aws_iam_role.codedeploy_role.arn}"

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  
  ecs_service {
    cluster_name = "${aws_ecs_cluster.cluster.name}"
    service_name = "${aws_ecs_service.service.name}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${aws_lb_listener.frontend_lb_listener.arn}"]
      }
      
      target_group {
        name = "${aws_lb_target_group.lb_target_blue.name}"
      }
     
      target_group {
        name = "${aws_lb_target_group.lb_target_green.name}"
      }
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    } 
  }
}
