resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "${var.project_name}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.db_admin_username
  password                = var.db_admin_password
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.database_sg_id]
  backup_retention_period = 0

  publicly_accessible = false
  multi_az            = false
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  tags = {
    Name = "${var.project_name}-mysql"
    Tier = "database"
  }
}
