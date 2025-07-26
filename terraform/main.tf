resource "aws_s3_object" "index_page" {
  bucket = module.s3_static.bucket_id
  key = "index.html"
  source = "./index.html"
  content_type = "text/html"
  etag = filemd5("./index.html")
}

module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_id                   = module.s3_static.bucket_id
  bucket_regional_domain_name = module.s3_static.bucket_regional_domain_name
}



# Lambda生成
module "index_lambda" {
  source = "./modules/lambda"
  function_name   = "main-func-lambda"
  runtime         = "python3.9"
  handler         = "app.handler"
  role_arn         = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("./latest.zip") 
  s3_bucket = module.s3_lambda.bucket_name
  s3_bucket_arn = module.s3_lambda.bucket_arn
  s3_key    = "test/latest.zip"
    # ここもポイント！！！
  depends_on = [
  aws_iam_role_policy.lambda_s3_access,
  aws_s3_bucket_policy.allow_lambda_getobject
]
}

# ほかのリソースでロールや ARN を使いたい場合
output "index_lambda_arn" {
  value = module.index_lambda.lambda_arn
}