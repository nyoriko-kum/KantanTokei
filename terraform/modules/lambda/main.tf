# IAMポリシーの本文を定義
data "aws_iam_policy_document" "role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-exec"
#   ここでポリシーを上記の内容で設定
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_lambda_function" "Lambda_function" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn

  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
}


