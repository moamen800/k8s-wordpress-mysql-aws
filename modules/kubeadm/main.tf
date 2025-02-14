# ------------------------------------------
# EC2 Instances for Kubernetes Cluster
# ------------------------------------------
resource "aws_instance" "k8s" {
  count           = 3
  ami             = "ami-0399a684c97d981a2"
  instance_type   = "t3.medium"             
  key_name        = "keypair"
  subnet_id       = var.subnet_ids[1]
  security_groups = [var.allow_all_sg_id]
  iam_instance_profile = aws_iam_instance_profile.k8s_instance_profile.name

  # Configure root volume sizes per node type
  root_block_device {
    volume_size = lookup(
      {
        0 = 20  # Master node storage: 20 GB
        1 = 10  # Worker node 1 storage: 10 GB
        2 = 10  # Worker node 2 storage: 10 GB
      },
      count.index,
      10
    )
    volume_type = "gp2" # General-purpose SSD
  }

  # Bootstrap Kubernetes nodes using user data scripts
  user_data = filebase64(
    lookup(
      {
        0 = "${path.module}/scripts/install-k8s-Master.sh"
        1 = "${path.module}/scripts/install-k8s-Node1.sh"
        2 = "${path.module}/scripts/install-k8s-Node2.sh"
      },
      count.index,
      ""
    )
  )

  # Assign appropriate names to the instances
  tags = {
    Name = lookup(
      {
        0 = "k8s-master"
        1 = "k8s-node1"
        2 = "k8s-node2"
      },
      count.index,
      "unknown"
    )
  }
}

# ------------------------------------------
# IAM Role for EC2 Instances (EBS & EFS Access)
# ------------------------------------------
resource "aws_iam_role" "k8s_ebs_efs_role" {
  name = "k8s-ebs-efs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# ------------------------------------------
# IAM Policy for EFS Access
# ------------------------------------------
resource "aws_iam_policy" "k8s_efs_policy" {
  name        = "k8s-efs-policy"
  description = "Policy to allow EKS nodes to manage EFS"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "ec2:DescribeAvailabilityZones"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = ["elasticfilesystem:CreateAccessPoint"],
        Resource = "*",
        Condition = {
          "StringLike" = {
            "aws:RequestTag/efs.csi.aws.com/cluster" = "true"
          }
        }
      },
      {
        Effect = "Allow",
        Action = ["elasticfilesystem:TagResource"],
        Resource = "*",
        Condition = {
          "StringLike" = {
            "aws:ResourceTag/efs.csi.aws.com/cluster" = "true"
          }
        }
      },
      {
        Effect = "Allow",
        Action = "elasticfilesystem:DeleteAccessPoint",
        Resource = "*",
        Condition = {
          "StringEquals" = {
            "aws:ResourceTag/efs.csi.aws.com/cluster" = "true"
          }
        }
      }
    ]
  })
}

# ------------------------------------------
# Attach EFS Policy to IAM Role
# ------------------------------------------
resource "aws_iam_role_policy_attachment" "k8s_efs_attachment" {
  policy_arn = aws_iam_policy.k8s_efs_policy.arn
  role       = aws_iam_role.k8s_ebs_efs_role.name
}

# ------------------------------------------
# Attach EBS Policy to IAM Role
# ------------------------------------------
resource "aws_iam_role_policy_attachment" "k8s_ebs_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.k8s_ebs_efs_role.name
}

# ------------------------------------------
# IAM Instance Profile for EC2 Instances
# ------------------------------------------
resource "aws_iam_instance_profile" "k8s_instance_profile" {
  name = "k8s-instance-profile"
  role = aws_iam_role.k8s_ebs_efs_role.name
}
