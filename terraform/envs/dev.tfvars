project_name          = "epicbook"
aws_region            = "ap-south-1"
vpc_cidr              = "10.20.0.0/16"
public_subnet_cidr    = "10.20.1.0/24"
private_subnet_cidr   = "10.20.2.0/24"
private_subnet_cidr_2 = "10.20.3.0/24"
instance_type         = "t3.micro"
db_instance_class     = "db.t3.micro"

allowed_admin_ip  = "102.90.125.177/32"
pipeline_agent_ip = "43.205.145.50/32"
backend_app_port  = 8080
db_name           = "epicbook"
