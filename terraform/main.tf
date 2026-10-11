terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

# Minimal IAM role for Lambda (if you prefer Terraform create it)
resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function (expects a zip artifact at terraform/lambda.zip)
resource "aws_lambda_function" "hello" {
  filename         = "${path.module}/lambda.zip"
  function_name    = var.lambda_function_name
  role             = var.role_arn_for_lambda != "" ? var.role_arn_for_lambda : aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")
  timeout          = 10

  tracing_config {
    mode = "PassThrough"
  }
}