data "aws_iam_policy_document" "bedrock_policy" {
  statement {
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream"
    ]

    resources = var.inference_profile_arns
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/bedrock/*",
      "arn:aws:logs:*:*:log-group:/aws/bedrock/*:log-stream:*"
    ]
  }
}

resource "aws_iam_policy" "bedrock_access" {
  name        = "bedrock-inference-profile-access-policy"
  description = "Policy for accessing Bedrock models via inference profile"
  policy      = data.aws_iam_policy_document.bedrock_policy.json
}

resource "aws_iam_role_policy_attachment" "bedrock_access" {
  role       = var.iam_role_name
  policy_arn = aws_iam_policy.bedrock_access.arn
}
