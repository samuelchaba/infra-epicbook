variable "project_name" {
  description = "Prefix used for AWS resource names and Name tags."
  type        = string
  default     = "epicbook"
}

variable "aws_region" {
  description = "AWS region in which to deploy the EpicBook infrastructure."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the EpicBook VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the frontend public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the backend subnet."
  type        = string
  default     = "10.20.2.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet used by the database tier."
  type        = string
  default     = "10.20.3.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for the frontend and backend."
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS instance class for the lab database."
  type        = string
  default     = "db.t3.micro"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for the EC2 key pair."
  type        = string
}

variable "allowed_admin_ip" {
  description = "CIDR block allowed to SSH to the frontend and backend instances."
  type        = string
}

variable "pipeline_agent_ip" {
  description = "CIDR block for the pipeline agent allowed to SSH to the frontend and backend instances."
  type        = string
}

variable "backend_app_port" {
  description = "TCP port exposed by the backend application to the frontend."
  type        = number
  default     = 8080
}

variable "db_admin_username" {
  description = "Administrator username for the RDS MySQL database."
  type        = string
  sensitive   = true
}

variable "db_admin_password" {
  description = "Administrator password for the RDS MySQL database."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the EpicBook MySQL database."
  type        = string
  default     = "epicbook"
}
