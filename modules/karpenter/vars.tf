variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}


variable "enabled" {
  type        = bool
  default     = true
}

variable "cluster_name" {
  type = string
}

variable "nodegroup_name" {
  type        = string
  description = "Nome do NodeGroup onde o Karpenter Controller deve ser agendado"
}


variable "eks_cluster_endpoint" {
  type = string
}

variable "eks_cluster_token" {
  type = string
}

variable "eks_cluster_certificate" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_identity_oidc_issuer" {
  type = string
}

variable "cluster_identity_oidc_issuer_arn" {
  type = string
}

variable "service_account_name" {
  type    = string
  default = "karpenter"
}

variable "helm_chart_name" {
  type    = string
  default = "karpenter"
}

variable "helm_chart_release_name" {
  type    = string
  default = "karpenter"
}

variable "karpenter_version" {
  type    = string
  default = "1.5.0"
}

variable "helm_chart_repo" {
  type    = string
  default = "oci://public.ecr.aws/karpenter"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "mod_dependency" {
  default = null
}

variable "settings" {
  default = {}
}

variable "ec2nodeclass_name" {
  default = "main"
  type        = string
  description = "Nome base para o EC2NodeClass e NodePool"
}

variable "nodepool_name" {
  default = "main"  
  type        = string
  description = "Nome base para o EC2NodeClass e NodePool"
}


