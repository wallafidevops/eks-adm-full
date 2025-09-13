vpc_cidr = "10.0.0.0/16"
vpc_name = "vpc"
azs = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
private_subnets = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
public_subnets = ["10.0.14.0/24", "10.0.15.0/24", "10.0.16.0/24"]


cluster_name = "cluster"
cluster_version = "1.33"
karpenter_version = "1.5.0"
alb_version = "1.13.3"
# kube_stack_version = "69.3.0"

version_argocd = "8.1.2"
