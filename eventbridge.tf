resource "aws_cloudwatch_event_rule" "config_resource_created" {
    name        = "aws-config-resource-created"
    description = "Triggered when a new resource is recorded by AWS Config"
    event_pattern = <<EOF
{
    "source": ["aws.config"],
    "detail-type": ["Config Configuration Item Change"],
    "detail": {
        "configurationItemStatus": ["ResourceDiscovered"]
    }
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.config_resource_created.name
    arn       = aws_lambda_function.lambda_tagger.arn
}