####################################### VPC ID Variable #######################################
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the MySQL resources"
  type        = list(string)
}

variable "allow_all_sg_id" {
  description = "The security group ID that allows all traffic"
  type        = string
}

# variable "alb_sg_id" {
#   description = "The security group ID for the Application Load Balancer (ALB)"
#   type        = string
# }

