vpc_cidr = "10.10.0.0/16"
vpc_name = "vpc"
azs = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
public_subnets = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]


cluster_name = "cluster"
cluster_version = "1.33"
karpenter_version = "1.6.0"
alb_version = "1.13.4"
# kube_stack_version = "69.3.0"

version_argocd = "7.8.28"


