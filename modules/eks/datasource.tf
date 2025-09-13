data "aws_eks_cluster" "cluster" {
  depends_on = [module.eks] #quando for subir ou alterar recurso comentar essa linha
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  depends_on = [module.eks] #quando for subir ou alterar recurso comentar essa linha
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "oidc_provider" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

data "aws_caller_identity" "current" {}

# Output the current account ID
output "current_account_id" {
  value = data.aws_caller_identity.current.account_id
}

data "aws_eks_addon_version" "vpc_cni" {
  addon_name   = "vpc-cni"
  kubernetes_version = module.eks.cluster_version
  most_recent = true
}

data "aws_eks_addon_version" "coredns" {
  addon_name   = "coredns"
  kubernetes_version = module.eks.cluster_version
  most_recent = true
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name   = "kube-proxy"
  kubernetes_version = module.eks.cluster_version
  most_recent = true
}

data "aws_eks_addon_version" "ebs_csi_driver" {
  addon_name   = "aws-ebs-csi-driver"
  kubernetes_version = module.eks.cluster_version
  most_recent = true
}

data "aws_ecrpublic_authorization_token" "token" {}
