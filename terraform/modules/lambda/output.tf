output "lambda_arn" {
  value = aws_lambda_function.visit_counter_lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.visit_counter_lambda.invoke_arn
}
