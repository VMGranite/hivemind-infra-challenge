variable "region" {
  description = "Region default for project"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, prod)"
  type        = string
  default     = "dev"
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to spread subnets across"
  type        = number
  default     = 2
}

variable "ecr_access_principal_arn" {
  description = "ARN of the IAM principal (CI role or local user) that needs read/write access to the ECR repository"
  type        = string
}

variable "managedByTerraform" {
  description = "Indicate a resource is managed by Terraform in Tags"
  type        = string
  default     = "Terraform"
}
