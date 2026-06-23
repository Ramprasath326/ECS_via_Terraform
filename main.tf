provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.2.0.0/16"
  az_count   = "2"
  aws_region = "us-east-1"
}

module "sg" {
  source     = "./modules/sg"
  vpc_id     = module.vpc.vpc_id
  cidr_block = module.vpc.cidr_block
}

module "alb" {
  source          = "./modules/alb"
  security_groups = [module.sg.web_sg_id]
  subnets         = module.vpc.public_subnet_ids
  vpc_id          = module.vpc.vpc_id
}