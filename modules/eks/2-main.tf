
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name   = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true


  vpc_id                   = var.vpc_id 
  
  # control_plane_subnet_ids = var.private_subnets
  control_plane_subnet_ids = var.public_subnets

  #subnet_ids               = module.vpc.private_subnets
  subnet_ids               = var.public_subnets
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      AdministratorAccess          = "arn:aws:iam::aws:policy/AdministratorAccess" 
    }    
  }

  # terraform taint module.eks.aws_eks_node_group.this["${terraform.workspace}-node"] //força criaçãos
  eks_managed_node_groups = {
    "${terraform.workspace}-node" = {
      name         = "node"
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = ["t3.medium"]
      subnet_ids     = var.public_subnets
      enable_public_ip = true
    }

 
  }

  

  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = var.workspace
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }


}

resource "aws_eks_addon" "coredns" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "coredns"
  addon_version               = data.aws_eks_addon_version.coredns.version
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = aws_iam_role.coredns_role.arn

  depends_on = [module.eks.eks_managed_node_groups]
 
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "kube-proxy"
  addon_version               = data.aws_eks_addon_version.kube_proxy.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.kube_proxy_role.arn

  depends_on = [module.eks.eks_managed_node_groups]

}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = data.aws_eks_addon_version.ebs_csi_driver.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.ebs_csi_driver_role.arn

  depends_on = [module.eks.eks_managed_node_groups]

}

module "karpenter" {
  source = "../karpenter"
  enabled = true
  cluster_name = module.eks.cluster_name
  aws_region = var.region
  eks_cluster_endpoint = data.aws_eks_cluster.cluster.endpoint
  eks_cluster_token = data.aws_eks_cluster_auth.cluster.token
  eks_cluster_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  cluster_identity_oidc_issuer = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
  cluster_identity_oidc_issuer_arn = data.aws_iam_openid_connect_provider.oidc_provider.arn
  ec2nodeclass_name             = "main"
  nodepool_name                 = "main"
  karpenter_version = var.karpenter_version
  mod_dependency = null
  aws_account_id = data.aws_caller_identity.current.account_id
  nodegroup_name = "${terraform.workspace}-node"
  
}

# resource "aws_eks_addon" "efs_csi_driver" {
#   cluster_name = module.eks.cluster_name
#   addon_name   = "aws-efs-csi-driver"
#   resolve_conflicts_on_create = "OVERWRITE"
#   resolve_conflicts_on_update = "OVERWRITE"
  
#   tags = {
#     Environment = terraform.workspace
#   }
# }


# terraform state rm module.alb_controller.helm_release.alb_controller
# antes helm repo add eks https://aws.github.io/eks-charts / helm repo update
module "alb_controller" {
  source                           = "../alb-controller"
  cluster_name                     = module.eks.cluster_name
  cluster_identity_oidc_issuer     = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
  cluster_identity_oidc_issuer_arn = data.aws_iam_openid_connect_provider.oidc_provider.arn
  aws_region                       = var.region
  eks_cluster_endpoint             = data.aws_eks_cluster.cluster.endpoint
  eks_cluster_token                = data.aws_eks_cluster_auth.cluster.token
  eks_cluster_certificate          = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)  
  alb_version = var.alb_version
}

# module "kube-stack" {
#   source                           = "../kube-stack"
#   cluster_identity_oidc_issuer     = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
#   cluster_identity_oidc_issuer_arn = data.aws_iam_openid_connect_provider.oidc_provider.arn
#   aws_region                       = var.region
#   eks_cluster_endpoint             = data.aws_eks_cluster.cluster.endpoint
#   eks_cluster_token                = data.aws_eks_cluster_auth.cluster.token
#   eks_cluster_certificate          = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data) 
#   kube_stack_version               = var.kube_stack_version


# }

module "argocd" {
  source = "../argocd"
  aws_region                       = var.region
  eks_cluster_endpoint             = data.aws_eks_cluster.cluster.endpoint
  eks_cluster_token                = data.aws_eks_cluster_auth.cluster.token
  eks_cluster_certificate          = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data) 
  version_argocd                   = var.version_argocd


}



#https://github.com/aidanmelen/terraform-aws-eks-auth

#https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest/submodules/aws-auth

# terraform state rm module.eks_auth.kubernetes_config_map_v1_data.aws_auth[0]
# AWS Auth Submodule
module "eks_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "${aws_iam_role.eks_nodegroup_role.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.cluster_name}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }    
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      username = "root"
      groups   = ["system:masters"]
    },    
    {
      userarn  = "${aws_iam_user.admin_user.arn}"
      username = "${aws_iam_user.admin_user.name}"
      groups   = ["system:masters"]
    },
    {
      userarn  = "${aws_iam_user.basic_user.arn}"
      username = "${aws_iam_user.basic_user.name}"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = concat([data.aws_caller_identity.current.account_id], var.additional_account_ids)
}

#terraform taint module.eks.aws_eks_node_group.this["new-node-group"] força recurso a subir
