variable "project_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "backend_subnet_id" {
  type = string
}

variable "frontend_sg_id" {
  type = string
}

variable "backend_sg_id" {
  type = string
}
