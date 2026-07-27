output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_web_subnet_ids" {
  value = [
    aws_subnet.private_web_a.id,
    aws_subnet.private_web_b.id
  ]
}

output "private_db_subnet_ids" {
  value = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}