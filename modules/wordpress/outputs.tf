output "alb_dns_name" {
  description = "Dns of the Alb"
  value       = aws_lb.alb.dns_name
}