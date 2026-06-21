variable "security_groups" {
  description = "List of security group IDs to associate with the ALB"
  type        = list(string)
  }

variable "subnets" {
  description = "List of subnet IDs to associate with the ALB" 
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}