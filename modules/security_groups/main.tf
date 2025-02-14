#######################################  Security Groups  #######################################
resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Security group that allows all inbound and outbound traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "allow-all-sg"
  }
}

# resource "aws_security_group" "alb_sg" {
#   name   = "alb_sg"
#   vpc_id = var.vpc_id

#   # HTTP Ingress (Port 80) – Allow incoming HTTP traffic to the ALB
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Outbound rule – Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" # -1 allows all traffic
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "alb-sg"
#   }
# }
