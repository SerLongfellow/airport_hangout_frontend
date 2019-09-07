
resource "aws_security_group" "ec2_security_group" {
  name             = "airport_hangout_frontend_ecs_instance_sg"
  description      = "Airport Hangout frontend ECS container instance SG"
}

resource "aws_security_group_rule" "ec2_inbound_ssh_rule" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
 
  security_group_id = "${aws_security_group.ec2_security_group.id}"
}

resource "aws_security_group_rule" "ec2_inbound_rule" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.lb_security_group.id}"
 
  security_group_id = "${aws_security_group.ec2_security_group.id}"
}

resource "aws_security_group_rule" "ec2_outbound_rule" {
  type         = "egress"
  from_port    = 0
  to_port      = 65535
  protocol     = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = "${aws_security_group.ec2_security_group.id}"
}

resource "aws_key_pair" "ec2" {
  key_name     = "ec2_key_pair"
  public_key   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCheG7YFqoK09FCIzZv6HsTjzRceMRiHmk0Z9aXrF4UJ+yQkeZJ7PjxrM9B3AuktRAiCIuKUQbfwtAlwzsVCUZO1BpOo0cxbRjsq6UGvwmWOl5qJ5VadPIC7KJjX43HqCXpSc76tXW47FmZ9Y1DysH5zNmslcfsP6IG+PwZds0TP6yakdtL1RIgsG3gg/v8tLKEa0T9svU/Fi0Zp7/cQligv7o2fF7VVhWEKzKgZlGyFAixcLkhPk1GgGBnsT9jgtVUiIeRVxE2uoq/wdtPw3cvvu6j7/Kb5r/RyVFd68MRqmR0HDXumS1SyR29GjXy2lCrcp9aBj9VlZftFI7a4GW6LRPyECQGX3ie+zNit9xxweVmxMTQ1c/gzXFUCxZH4XN1fypSigOOfxiGcH7WZC6FqgJom8682aSEpEeIb8DZoVhFEgc4MIBDud6ZSWrJpic9jydzVxR8IX5vlQ0Ult1K6CwlFla5wLfA6KGxyWOM7ZID4sSEJwZiFaodMKtAdGs= jlong@archlinux"
}

resource "aws_iam_role" "ecs_role" {
  name = "airport_hangout_frontend_ecs_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_policy" {
  name = "airport_hangout_frontend_ecs_policy"
  role = "${aws_iam_role.ecs_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs" {
  name = "airport_hangout_frontend_ecs_instance_profile"
  role = "${aws_iam_role.ecs_role.name}"
}

resource "aws_instance" "ecs_cluster_instance" {
  ami                    = "ami-0fac5486e4cff37f4"
  instance_type          = "t2.small"
  availability_zone      = "us-east-1a"
  key_name               = "${aws_key_pair.ec2.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
  vpc_security_group_ids = ["${aws_security_group.ec2_security_group.id}"]
  
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
}
