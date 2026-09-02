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

variable "ecr_access_principal_arn" {
  description = "ARN of the IAM principal (CI role or local user) that needs read/write access to the ECR repository"
  type        = string
}
