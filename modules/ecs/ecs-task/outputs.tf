output "task_role_name" {
  value = aws_iam_role.ecs_task_role.name
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "task_execution_role_name" {
  value = aws_iam_role.ecs_task_execution_role.name
}

output "task_execution_role_id" {
  value = aws_iam_role.ecs_task_execution_role.id
}

output "task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "task_arn" {
  value = aws_ecs_task_definition.app_task.arn
}

output "task_id" {
  value = aws_ecs_task_definition.app_task.id
}