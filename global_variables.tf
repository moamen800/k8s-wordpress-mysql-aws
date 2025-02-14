####################################### Provider Variables #######################################
# Configuration for AWS provider
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  default     = "default"
}
