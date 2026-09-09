output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "Full URL of the ECR repository, e.g. <account-id>.dkr.ecr.<region>.amazonaws.com/<name>"
  value       = module.ecr.repository_url
}

# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = aws_vpc.main.id
# }

# output "public_subnet_ids" {
#   description = "IDs of the public subnets"
#   value       = aws_subnet.public[*].id
# }

# output "private_subnet_ids" {
#   description = "IDs of the private subnets (EKS worker nodes)"
#   value       = aws_subnet.private[*].id
# }
