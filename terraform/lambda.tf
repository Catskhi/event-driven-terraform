resource "aws_lambda_function" "lambda_function" {
    function_name = "${var.project_name}-${var.environment}-lambda-function"
    role         = aws_iam_role.lambda-role.arn
    handler       = "index.handler"
    runtime      = "nodejs20.x"
    filename = "lambda.zip"
    environment {
        variables = {
            TABLE_NAME = aws_dynamodb_table.tasks.name
        }
    }
}