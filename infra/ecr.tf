module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                   = "hivemind-${var.environment}-ecr-private"
  repository_read_write_access_arns = [var.ecr_access_principal_arn]
  repository_image_scan_on_push     = true
  repository_image_tag_mutability   = "IMMUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus      = "tagged",
          tagPatternList = ["*"],
          countType      = "imageCountMoreThan",
          countNumber    = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = var.managedByTerraform
  }
}