
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "com.jefflong.airporthangout.ops"
    key    = "frontend/infrastructure/application-terraform-state.tfstate"
    region = "us-east-1"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "airport_hangout_frontend_cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                = "airport_hangout_frontend_ecs_task"
  container_definitions = <<EOF
[
  {
    "name": "frontend",
    "image": "airport-hangout-frontend",
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
