
# Modulo de Vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.16"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = false
  enable_vpn_gateway = false
  single_nat_gateway     = true  
  map_public_ip_on_launch = true

  tags = {
    Environment = var.workspace
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                 = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "karpenter.sh/discovery" = var.cluster_name
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"        = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    # Para Karpenter auto-discovery:

  }
}  

