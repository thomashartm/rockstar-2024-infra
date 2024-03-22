output "arn" {
  value = module.python_lambda.lambda_function_arn
}

output "invoke_arn" {
  value = module.python_lambda.lambda_function_invoke_arn
}

output "function_name" {
  value = module.python_lambda.lambda_function_name
}

output "lambda_role_arn" {
  value = module.python_lambda.lambda_role_arn
}

output "lambda_role_name" {
  value = module.python_lambda.lambda_role_name
}
