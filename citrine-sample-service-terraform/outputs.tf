
# outputs.tf

output "alb_hostname" {
  value = aws_alb.main.dns_name
}

output "repository_url" {
  value = aws_ecr_repository.punch_repository.repository_url
}
