resource "aws_apigatewayv2_api" "main" {
    name         = "${var.project_name}-${var.environment}-api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
    api_id = aws_apigatewayv2_api.main.id
    integration_type = "AWS_PROXY"
    integration_uri = aws_lambda_function.lambda_function.invoke_arn
    integration_method = "POST"
    payload_format_version = "2.0"
}

  resource "aws_apigatewayv2_route" "get_tasks" {                                                        
      api_id    = aws_apigatewayv2_api.main.id                                                           
      route_key = "GET /tasks"                                                                           
      target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"                               
      authorization_type = "JWT"                                                                         
      authorizer_id      = aws_apigatewayv2_authorizer.cognito.id                                        
  }                                                                                                      
                                                                                                         
  resource "aws_apigatewayv2_route" "post_tasks" {                                                       
      api_id    = aws_apigatewayv2_api.main.id                                                           
      route_key = "POST /tasks"                                                                          
      target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"                               
      authorization_type = "JWT"                                                                         
      authorizer_id      = aws_apigatewayv2_authorizer.cognito.id                                        
  }                                                                                                      
                                                                                                         
  resource "aws_apigatewayv2_route" "put_task" {                                                         
      api_id    = aws_apigatewayv2_api.main.id                                                           
      route_key = "PUT /tasks/{id}"                                                                      
      target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"                               
      authorization_type = "JWT"                                                                         
      authorizer_id      = aws_apigatewayv2_authorizer.cognito.id                                        
  }                                                                                                      
                                                                                                         
  resource "aws_apigatewayv2_route" "delete_task" {                                                      
      api_id    = aws_apigatewayv2_api.main.id                                                           
      route_key = "DELETE /tasks/{id}"                                                                   
      target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"                               
      authorization_type = "JWT"                                                                         
      authorizer_id      = aws_apigatewayv2_authorizer.cognito.id                                        
  }           

resource "aws_apigatewayv2_stage" "default" {
    api_id = aws_apigatewayv2_api.main.id
    name = var.environment
    auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway" {
    statement_id = "AllowAPIGateway"
    action       = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_function.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id = aws_apigatewayv2_api.main.id
  authorizer_type = "JWT"
  name = "cognito-authorizer"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.main.id}"  
    audience = [aws_cognito_user_pool_client.main.id]
  }
}