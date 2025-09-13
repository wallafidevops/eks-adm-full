variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}


variable "vpc_name" {
  description = "The name of the VPC."
}

variable "vpc_cidr" {
  description = "CIDR blocks for the VPCs"
  type        = string
  
}

variable "azs" {
  description = "A list of availability zones in the region."
  type        = list(string)  
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

variable "additional_account_ids" {
  type    = list(string)
  default = ["931783206580"] # Add your additional account IDs here
}

variable "cluster_version" {  
  type    = string
  default = "1.31"
  
}

variable "karpenter_version" {  
  type        = string
  default     = "1.5.0"
  description = "Karpenter Helm chart version."
  
}

variable "alb_version" {
  type        = string
  description = "ALB Controller Helm chart version."
}

# variable "kube_stack_version" {
#   type        = string
#   description = "Kube stack version."
  
# }

variable "version_argocd" {
  type        = string
  description = "ArgoCD version."

  
}
