variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr_2" {
  type = string
}

variable "allowed_admin_ip" {
  type = string
}

variable "pipeline_agent_ip" {
  type = string
}

variable "backend_app_port" {
  type = number
}
