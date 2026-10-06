module "network" {
  source = "./modules/network"

  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  allowed_admin_ip      = var.allowed_admin_ip
  pipeline_agent_ip     = var.pipeline_agent_ip
  backend_app_port      = var.backend_app_port
}

module "compute" {
  source = "./modules/compute"

  project_name        = var.project_name
  instance_type       = var.instance_type
  ssh_public_key_path = var.ssh_public_key_path

  public_subnet_id  = module.network.public_subnet_id
  backend_subnet_id = module.network.backend_subnet_id
  frontend_sg_id    = module.network.frontend_sg_id
  backend_sg_id     = module.network.backend_sg_id
}

module "database" {
  source = "./modules/database"

  project_name      = var.project_name
  db_instance_class = var.db_instance_class
  db_admin_username = var.db_admin_username
  db_admin_password = var.db_admin_password
  db_name           = var.db_name
  db_subnet_ids     = module.network.db_subnet_ids
  database_sg_id    = module.network.database_sg_id
}
