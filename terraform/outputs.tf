output "app_public_ip" {
  description = "Public IP address of the frontend instance."
  value       = module.compute.frontend_public_ip
}

output "backend_ansible_host" {
  description = "Public IP address of the backend instance for Ansible management."
  value       = module.compute.backend_public_ip
}

output "backend_private_ip" {
  description = "Private IP address of the backend instance for internal application traffic."
  value       = module.compute.backend_private_ip
}

output "mysql_fqdn" {
  description = "DNS endpoint of the RDS MySQL instance."
  value       = module.database.mysql_fqdn
}
