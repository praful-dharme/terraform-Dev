resource "aws_security_group" "alb_sg" {

  name        = "alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

locals {
  ec2_ports = [80, 3000, 4200, 8080]
}

resource "aws_security_group" "ec2_sg" {

  name        = "ec2-sg"
  description = "Backend EC2 Security Group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {

    for_each = local.ec2_ports

    content {

      description = "Port ${ingress.value} from ALB"

      from_port = ingress.value
      to_port   = ingress.value

      protocol = "tcp"

      security_groups = [
        aws_security_group.alb_sg.id
      ]
    }
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}


resource "aws_security_group" "rds_sg" {

  name        = "rds-sg"
  description = "RDS Security Group"

  vpc_id = var.vpc_id

  ingress {

    description = "MYSQL"

    from_port = 3306
    to_port   = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}