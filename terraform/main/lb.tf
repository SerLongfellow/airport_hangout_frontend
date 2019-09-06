
resource "aws_security_group" "lb_security_group" {
  name             = "airport_hangout_frontend_lb_sg"
  description      = "Airport Hangout frontend load balancer SG"
}

resource "aws_security_group_rule" "lb_inbound_rule" {
  type         = "ingress"
  from_port    = 80
  to_port      = 80
  protocol     = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = "${aws_security_group.lb_security_group.id}"
}

resource "aws_security_group_rule" "lb_outbound_rule" {
  type         = "egress"
  from_port    = 3000
  to_port      = 3000
  protocol     = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = "${aws_security_group.lb_security_group.id}"
}

resource "aws_default_vpc" "default_vpc" {

}

resource "aws_default_subnet" "subnet_az1" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "subnet_az2" {
  availability_zone = "us-east-1b"
}

resource "aws_lb" "frontend_lb" {
  name               = "airport-hangout-frontend-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb_security_group.id}"]
  subnets            = ["${aws_default_subnet.subnet_az1.id}", "${aws_default_subnet.subnet_az2.id}"]

  timeouts {
    create = "10m"
  }
  
}

resource "aws_lb_target_group" "lb_target_blue" {
  name       = "frontend-lb-target-blue"
  port       = 3000
  protocol   = "HTTP"
  vpc_id     = "${aws_default_vpc.default_vpc.id}"
  
  depends_on = ["aws_lb.frontend_lb"]
}

resource "aws_lb_target_group" "lb_target_green" {
  name        = "frontend-lb-target-green"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = "${aws_default_vpc.default_vpc.id}"
  
  depends_on = ["aws_lb.frontend_lb"]
}

resource "aws_lb_listener" "frontend_lb_listener" {
  load_balancer_arn = "${aws_lb.frontend_lb.arn}"
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb_target_blue.arn}"
  }
}

resource "aws_lb_listener" "frontend_lb_listener_secondary" {
  load_balancer_arn = "${aws_lb.frontend_lb.arn}"
  port              = "8080"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb_target_green.arn}"
  }
}
