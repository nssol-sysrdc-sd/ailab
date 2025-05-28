resource "aws_cloudwatch_log_group" "bedrock_logs" {
  name              = var.log_group_name
  retention_in_days = 30

  tags = {
    Name        = "Bedrock Model Invocation Logs"
    Environment = "production"
  }
}

data "aws_iam_policy_document" "bedrock_log_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["${aws_cloudwatch_log_group.bedrock_logs.arn}:*"]
  }
}

resource "aws_cloudwatch_log_resource_policy" "bedrock_log_policy" {
  policy_name     = "bedrock-logging-policy"
  policy_document = data.aws_iam_policy_document.bedrock_log_policy_document.json
}

# Update the outputs to include the log group ARN
output "bedrock_log_group_arn" {
  description = "ARN of the CloudWatch log group for Bedrock"
  value       = aws_cloudwatch_log_group.bedrock_logs.arn
}
