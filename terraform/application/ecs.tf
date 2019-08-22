
resource "aws_ecs_cluster" "cluster" {
  name = "airport_hangout_frontend_cluster"
}


resource "aws_iam_role" "ecs_execution_role" {
  name = "airport_hangout_frontend_ecs_task_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
           "ecs.amazonaws.com",
           "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_execution_policy" {
  name = "airport_hangout_frontend_ecs_task_execution_policy"
  role = "${aws_iam_role.ecs_execution_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:Describe*",
        "ecs:List*",
        "ecs:Poll",
        "ecs:Start*",
        "ecs:Submit*",
        "ecs:Update*"
      ],
      "Resource": "${aws_ecs_cluster.cluster.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_ecs_task_definition" "task" {
  family                = "airport_hangout_frontend_ecs_task"
  execution_role_arn    = "${aws_iam_role.ecs_execution_role.arn}"
  container_definitions = <<EOF
[
  {
    "name": "frontend",
    "image": "394069212708.dkr.ecr.us-east-1.amazonaws.com/airport_hangout_ecr_repo/airport-hangout-frontend:latest",
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "service" {
  name                = "airport_hangout_frontend_service"
  cluster             = "${aws_ecs_cluster.cluster.id}"
  task_definition     = "${aws_ecs_task_definition.task.arn}"
  desired_count       = 1
  scheduling_strategy = "REPLICA"
}
