# IAMポリシーの本文を定義
# data "aws_iam_policy_document" "role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     effect  = "Allow"
#     principals {
#       identifiers = ["lambda.amazonaws.com"]
#       type        = "Service"
#     }
#   }
# }

# resource "aws_iam_role" "lambda_exec" {
#   name = "${var.function_name}-exec"
# #   ここでポリシーを上記の内容で設定
#   assume_role_policy = data.aws_iam_policy_document.role.json
# }

# # S3 読み取りポリシー
# data "aws_iam_policy_document" "s3_access" {
#   statement {
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket"
#     ]
#     resources = [
#       var.s3_bucket_arn,        # バケット自体
#       "${var.s3_bucket_arn}/*"       # 中のオブジェクト
#     ]
#     effect = "Allow"
#   }
# }

# resource "aws_iam_policy" "lambda_s3_access" {
#   name   = "${var.function_name}-s3-access"
#   policy = data.aws_iam_policy_document.s3_access.json
# }

# # 実行ロールに S3 アクセス権を付与
# resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = aws_iam_policy.lambda_s3_access.arn
# }

resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  source_code_hash = var.source_code_hash     # 変更検知用
  
  timeout          = 10
}


