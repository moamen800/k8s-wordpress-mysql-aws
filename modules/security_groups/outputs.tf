####################################### Security Group Outputs #######################################
output "allow_all_sg_id" {
  description = "ID of the presentation business_logiclication load balancer security group"
  value       = aws_security_group.allow_all.id
}

# output "alb_sg_id" {
#   description = "ID of the presentation business_logiclication load balancer security group"
#   value       = aws_security_group.alb_sg.id
# }


