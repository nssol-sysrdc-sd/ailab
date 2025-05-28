data "aws_caller_identity" "current" {}

locals {
  github_repo = "nssol-sysrdc-sd/ailab"
  region      = "ap-northeast-1"
  account_id  = data.aws_caller_identity.current.account_id
}

module "iam" {
  source      = "../modules/iam"
  github_repo = local.github_repo
}

module "bedrock" {
  source        = "../modules/bedrock"
  iam_role_name = module.iam.github_actions_role_name
  inference_profile_arns = [
    "arn:aws:bedrock:*:${local.account_id}:inference-profile/apac.anthropic.claude-sonnet-4-20250514-v1:0",
    "arn:aws:bedrock:*:${local.account_id}:inference-profile/apac.anthropic.claude-3-7-sonnet-20250219-v1:0",
    "arn:aws:bedrock:*:${local.account_id}:inference-profile/apac.anthropic.claude-3-5-sonnet-20241022-v2:0",
    "arn:aws:bedrock:*::foundation-model/anthropic.claude-sonnet-4-20250514-v1:0",
    "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-7-sonnet-20250219-v1:0",
    "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-5-sonnet-20241022-v2:0"
  ]
  log_group_name = "/aws/bedrock/model-invocations-${local.region}"
}

output "iam_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = module.iam.github_actions_role_arn
}

output "bedrock_policy_arn" {
  description = "ARN of the Bedrock access policy"
  value       = module.bedrock.bedrock_policy_arn
}

output "bedrock_log_group_name" {
  description = "Name of the CloudWatch log group for Bedrock"
  value       = module.bedrock.bedrock_log_group_name
}
