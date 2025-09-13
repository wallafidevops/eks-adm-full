
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

variable "version_argocd" {
  type        = string
  description = "ArgoCD version."
  default = "8.1.2"
  
}


