resource "aws_iam_role_policy_attachment" "database_access_policy_attachment" {
  role       = module.python_lambda.lambda_role_name
  policy_arn = var.database_access_policy_arn
}