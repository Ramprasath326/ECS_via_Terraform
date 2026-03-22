output "ecr_reporitory_url" {
  value = aws_ecr_repository.nginx.repository_url
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}