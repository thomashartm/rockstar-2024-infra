locals {
  # the following policy has a fixed value for the actual principal as it is used to enable jenkins
  access_permission_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "ECR Power User Access Policy",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.cicd_access_role}"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImages",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    },{
      "Sid": "ECR User Access Policy",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.user_access_role}"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImages",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    }
  ]
}
EOF

  effective_repository_policy = length(var.repository_policy) > 0 ? var.repository_policy : local.access_permission_policy

  cleanup_default_lifecycle_policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "remove old images",
      "selection": {
        "tagStatus": "untagged",
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

  effective_lifecycle_policy = length(var.lifecycle_policy) > 0 ? var.lifecycle_policy : local.cleanup_default_lifecycle_policy
}

resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.name
  tags                 = var.tags
  image_tag_mutability = var.immutable ? "IMMUTABLE" : "MUTABLE"

  image_scanning_configuration {
    scan_on_push       = var.scan_on_push
  }

  encryption_configuration {
    encryption_type     = var.encryption_type
    kms_key             = length(var.kms_key_arn) > 0 ? var.kms_key_arn : null
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.ecr_repository.name
  policy     = local.effective_lifecycle_policy
}

resource "aws_ecr_repository_policy" "main" {
  #count = length(var.repository_policy) > 0 ? 1 : 0
  repository = aws_ecr_repository.ecr_repository.name
  policy     = local.effective_repository_policy
}