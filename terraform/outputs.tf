output "output_url" {
    description = "The URL of the API Gateway"
    value = aws_apigatewayv2_stage.default.invoke_url
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value = aws_dynamodb_table.tasks.name
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool Id"
  value = aws_cognito_user_pool.main.id
}

output "cognito_client_id" {
  description = "Cognito Client ID for the app"
  value = aws_cognito_user_pool_client.main.id
}