data "archive_file" "lambda_tagger" {
  type        = "zip"
  source_dir  = "${path.module}/backend"
  output_path = "${path.module}/lambda.zip"
}

# Lambda function
resource "aws_lambda_function" "lambda_tagger" {
  filename         = data.archive_file.lambda_tagger.output_path
  function_name    = var.function_name
  role             = aws_iam_role.lambda_tagger.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda_tagger.output_base64sha256
  timeout          = 60

  runtime = "python3.13"

  environment {
    variables = {
      LOG_LEVEL      = "info"
    }
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
    statement_id  = "AllowExecutionFromEventBridge"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_tagger.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.config_resource_created.arn
}

resource "aws_cloudwatch_log_group" "lambda_tagger" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_tagger.function_name}"
  retention_in_days = var.retention_in_days
}