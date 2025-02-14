module "kubeadm" {
  source           = "./modules/kubeadm"
  vpc_id           = data.aws_vpc.default.id
  subnet_ids       = data.aws_subnets.default.ids
  allow_all_sg_id  = module.security_groups.allow_all_sg_id
}

module "security_groups" {
  source  = "./modules/security_groups"
  vpc_id  = data.aws_vpc.default.id
}

module "mysql" {
  source        = "./modules/mysql"
}

# module "wordpress" {
#   source                   = "./modules/wordpress"
#   vpc_id                   = data.aws_vpc.default.id
#   subnet_ids               = data.aws_subnets.default.ids
#   allow_all_sg_id          = module.security_groups.allow_all_sg_id
#   # alb_sg_id              = module.security_groups.alb_sg_id
#   # depends_on             = [module.mysql]
# }
