variable "project_name" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_admin_username" {
  type      = string
  sensitive = true
}

variable "db_admin_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "database_sg_id" {
  type = string
}
