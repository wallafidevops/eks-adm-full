variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
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
  type        = string
  description = "AWS region where secrets are stored."
  default = "us-east-1"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy ALB Controller Helm chart."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}

variable "kube_stack_version" {
  type        = string
  description = "Kube stack version."
  # default = "68.2.1"
  
}