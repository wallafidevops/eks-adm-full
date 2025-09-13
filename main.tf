module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = "${var.vpc_name}-${terraform.workspace}"
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  workspace = terraform.workspace
  cluster_name = "${var.cluster_name}-${terraform.workspace}"

}

module "eks" {
  source = "./modules/eks"
  cluster_name =  "${var.cluster_name}-${terraform.workspace}"
  cluster_version = var.cluster_version
  workspace = terraform.workspace
  additional_account_ids = var.additional_account_ids
  private_subnets = module.vpc.private_subnets
  public_subnets = module.vpc.public_subnets
  
  vpc_id = module.vpc.vpc_id
  karpenter_version = var.karpenter_version
  alb_version = var.alb_version
  # kube_stack_version = var.kube_stack_version
  version_argocd = var.version_argocd





}