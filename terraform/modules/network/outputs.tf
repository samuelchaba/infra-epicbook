output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "backend_subnet_id" {
  value = aws_subnet.backend.id
}

output "db_subnet_ids" {
  value = [aws_subnet.backend.id, aws_subnet.database.id]
}

output "frontend_sg_id" {
  value = aws_security_group.frontend.id
}

output "backend_sg_id" {
  value = aws_security_group.backend.id
}

output "database_sg_id" {
  value = aws_security_group.database.id
}
