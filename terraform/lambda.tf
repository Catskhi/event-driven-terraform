resource "aws_lambda_function" "lambda_function" {
    function_name = "${var.project_name}-${var.environment}-lambda-function"
    role         = aws_iam_role.lambda-role.arn
    handler       = "index.handler"
    runtime      = "nodejs20.x"
    filename = data.archive_file.lambda.output_path
    source_code_hash = data.archive_file.lambda.output_base64sha256
    environment {
        variables = {
            TABLE_NAME = aws_dynamodb_table.tasks.name
        }
    }
}