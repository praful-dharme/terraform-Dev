resource "aws_autoscaling_group" "backend" {

  name = "Backend-API-ASG"

  desired_capacity = 2
  min_size         = 2
  max_size         = 3

  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60


  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50

      instance_warmup = 30
    }

    triggers = ["launch_template"]
  }



  tag {
    key                 = "Name"
    value               = "Backend-API-Server"
    propagate_at_launch = true
  }
}