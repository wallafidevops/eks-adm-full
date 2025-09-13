terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.14.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  token                  = var.eks_cluster_token
  cluster_ca_certificate = var.eks_cluster_certificate
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    token                  = var.eks_cluster_token
    cluster_ca_certificate = var.eks_cluster_certificate
  }
}

provider "kubectl" {
  host                   = var.eks_cluster_endpoint
  token                  = var.eks_cluster_token
  cluster_ca_certificate = var.eks_cluster_certificate
  load_config_file       = false
}
