variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the security group will be created."
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}