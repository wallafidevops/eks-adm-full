variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_id" {
  description = "The ID of the VPC."
  
}

variable "private_subnets" {
  description = "Private subnets for each environment"
  type        = list(string)

}

variable "public_subnets" {
  description = "Public subnets for each environment"
  type        = list(string)

} 

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.31"
  
}

variable "additional_account_ids" {
  type    = list(string)
  default = ["931783206580"] # Add your additional account IDs here
}

variable "workspace" {
  type = string
}

variable "karpenter_version" {  
  type        = string
  default     = "1.5.0"
  description = "Karpenter Helm chart version."
  
}

variable "alb_version" {
  type        = string
  default     = "1.13.3"
  description = "ALB Controller Helm chart version."
}

# variable "kube_stack_version" {
#   type        = string
#   description = "Kube stack version."
#   # default = "68.2.1"
  
# }

variable "version_argocd" {
  type        = string
  description = "ArgoCD version."
  default = "8.1.2"
  
  
}
