output "db_endpoint" {
  value = aws_db_instance.mysql.address
}

output "db_port" {
  value = aws_db_instance.mysql.port
}