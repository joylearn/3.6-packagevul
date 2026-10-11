variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "lambda_function_name" {
  type    = string
  default = "hello-world-nodejs"
}

variable "role_arn_for_lambda" {
  description = "ARN of IAM role to be used by Lambda (created below or supplied)"
  type        = string
  default     = ""
}
