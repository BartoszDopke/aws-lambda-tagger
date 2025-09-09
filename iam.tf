
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "tagging_policy" {
  statement {
    actions = [
      "tag:TagResources",
      "tag:CreateTag",
      "tag:UntagResources"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "tagging_policy" {
  name   = "LambdaTaggerPolicy"
  policy = data.aws_iam_policy_document.tagging_policy.json
}

resource "aws_iam_role" "lambda_tagger" {
  name               = "lambda_tagger_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_tagger" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_tagger.name
}

resource "aws_iam_role_policy_attachment" "tagging_policy_attachment" {
  role       = aws_iam_role.lambda_tagger.name
  policy_arn = aws_iam_policy.tagging_policy.arn
}
