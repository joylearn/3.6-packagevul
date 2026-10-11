variable "region" {
  description = "AWS region used by the Lambda deployment."
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_account_id" {
  description = "AWS account ID shown in the AWS console screenshot."
  type        = string
  default     = "255945442255"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "lambda_function_name" {
  description = "Lambda function name managed by the deployment workflow."
  type        = string
  default     = "hello-world-nodejs"
}

variable "github_repository_owner" {
  description = "GitHub account or organization that owns the repository."
  type        = string
  default     = "joylearn"
}

variable "github_repository_name" {
  description = "GitHub repository allowed to assume the deployment role."
  type        = string
  default     = "3.6-packagevul"
}

variable "github_actions_role_name" {
  description = "Name of the IAM role assumed by the GitHub Actions workflow."
  type        = string
  default     = "JL36-GitHubActionsTerraformDeploy"
}
