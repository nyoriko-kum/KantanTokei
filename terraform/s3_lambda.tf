module "s3_lambda" {
    source        = "./modules/s3_public_deny"
    bucket_prefix = "lambda-source"
    enable_versioning = true  # 明示的に有効化
}

