####################################### Application Load Balancer (ALB) #######################################
# Create an Application Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = "alb"                      # Name of the ALB
  internal           = false                      # Set to false for internet-facing ALB
  load_balancer_type = "application"              # Type of load balancer (Application Load Balancer)
  subnets            = var.subnet_ids             # Use the subnet IDs from variables
  security_groups    = [var.allow_all_sg_id]      # Use the security group ID from variables

  tags = {
    Name = "Internet-Facing App Load Balancer"    # Tag for identifying the ALB
  }
}

####################################### ALB Listener #######################################
# Add a Listener to the ALB to forward HTTP traffic to the Target Group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn              # Associate with the ALB's ARN
  port              = 80                          # Set the listener port to 80 (HTTP)
  protocol          = "HTTP"                      # Protocol used by the listener

  default_action {
    type             = "forward"                  # Forward traffic
    target_group_arn = aws_lb_target_group.target_group.arn # Forward traffic to the target group
  }
}

####################################### ALB Target Group #######################################
# Create a Target Group for the ALB to route traffic
resource "aws_lb_target_group" "target_group" {
  name     = "target-group"     # Name of the target group
  port     = 80                 # Port for the target group (80 for HTTP)
  protocol = "HTTP"             # Protocol used for routing traffic
  vpc_id   = var.vpc_id         # VPC ID for the target group

  # Health check configuration for the target group
  health_check {
    interval            = 30     # Time between health checks (in seconds)
    path                = "/"    # Path used to check the health of the targets
    protocol            = "HTTP" # Protocol for the health check
    timeout             = 5      # Timeout for health checks (in seconds)
    healthy_threshold   = 2      # Number of successful health checks required to consider the target healthy
    unhealthy_threshold = 2      # Number of failed health checks required to consider the target unhealthy
  }

  tags = {
    Name = "Target Group"        # Tag for identifying the target group
  }
}