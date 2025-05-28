variable "iam_role_name" {
  description = "Name of the IAM role to attach Bedrock policies to"
  type        = string
}

variable "inference_profile_arns" {
  description = "ARN of the inference profile to invoke"
  type        = list(string)
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group for Bedrock logs"
  type        = string
  default     = "/aws/bedrock/model-invocations"
}
