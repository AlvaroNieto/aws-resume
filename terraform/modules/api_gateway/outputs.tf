output "api_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "api_stage" {
  value = aws_api_gateway_stage.api_stage.stage_name
}

output "api_path" {
  value = aws_api_gateway_resource.lambda_resource.path_part
}

output "api_full" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}${aws_api_gateway_stage.api_stage.stage_name}/${aws_api_gateway_resource.lambda_resource.path_part}"
}
