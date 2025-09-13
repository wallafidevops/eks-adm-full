terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

provider "helm" {
    kubernetes {

      host                   = var.eks_cluster_endpoint
      token                  = var.eks_cluster_token
      cluster_ca_certificate = var.eks_cluster_certificate
    }
}