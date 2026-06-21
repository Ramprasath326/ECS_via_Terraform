output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr_block" {
  value = module.vpc.cidr_block
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}