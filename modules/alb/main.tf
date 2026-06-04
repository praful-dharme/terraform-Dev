resource "aws_lb" "alb" {

  name               = "backend-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_sg_id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name = "backend-alb"
  }
}


resource "aws_lb_target_group" "backend" {

  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.backend.arn
  }
}


resource "aws_autoscaling_attachment" "asg" {

  autoscaling_group_name = var.asg_name

  lb_target_group_arn = aws_lb_target_group.backend.arn
}
