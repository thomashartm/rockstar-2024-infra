data "aws_secretsmanager_secret" "rds_secret_by_name" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret" "openai_ai_secret_by_name" {
  name = var.open_api_key_secret_name
}

data "aws_iam_policy_document" "allowed_secrets" {
  statement {
    effect  = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_get_secret_policy_policy" {
  name   = "${var.name}_${var.environment}_get_secret_policy"
  policy = data.aws_iam_policy_document.allowed_secrets.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_get_secret_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_get_secret_policy_policy.arn
  role       = module.ecs_task_definition.task_role_name
}

resource "aws_iam_role_policy_attachment" "ecs_exec_get_secret_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_get_secret_policy_policy.arn
  role       = module.ecs_task_definition.task_execution_role_name
}

#data "aws_iam_policy_document" "rds_db_proxy_policy_doc" {
#  statement {
#    effect = "Allow"
#
#    principals {
#      type        = "Service"
#      identifiers = ["rds.amazonaws.com"]
#    }
#
#    actions = ["sts:AssumeRole"]
#  }
#}
#
#resource "aws_iam_policy" "ecs_gdb_access_policy" {
#  name   = "${var.name}_${var.environment}_db_access_policy"
#  policy = data.aws_iam_policy_document.rds_db_proxy_policy_doc.json
#  tags   = var.tags
#}
#
#resource "aws_iam_role_policy_attachment" "cs_gdb_access_policy_attachment" {
#  policy_arn = aws_iam_policy.ecs_gdb_access_policy.arn
#  role       = module.ecs_task_definition.task_role_name
#}