variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default = "lambda-tagger"
}

variable "retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}