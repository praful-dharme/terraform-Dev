resource "aws_db_subnet_group" "mysql" {

  name = "mysql-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "mysql-subnet-group"
  }
}



resource "aws_db_instance" "mysql" {

  identifier = "mysql-db"

  engine         = "mysql"
  engine_version = "8.4.8"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  storage_type = "gp3"

  db_name = "appdb"

  username = var.db_username

  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  multi_az = false

  deletion_protection = false

  backup_retention_period = 7
}