module "s3_static" {
  source        = "./modules/s3_public_deny"
  bucket_prefix = "static-www"
}


resource "aws_s3_bucket_website_configuration" "static" {
  bucket = module.s3_static.bucket_id
  index_document { suffix = "index.html" }
}

# 4. OAI にだけアクセスを許可するポリシー生成
data "aws_iam_policy_document" "static-www"{
    statement {
        sid = "Allow CloudFront"
        effect = "Allow"
        principals {
          type = "AWS"
          identifiers = [module.cloudfront.origin_access_identity_iam_arn]
        }
        actions = [
            "s3:GetObject"
        ]

        resources = [
            "${module.s3_static.bucket_arn}/*"
        ]
    }
}

# resource bucketに右辺を代入し、policyに右辺を代入してポリシーとバケットを設定。
resource "aws_s3_bucket_policy" "static_policy" {
  bucket = module.s3_static.bucket_id
  policy = data.aws_iam_policy_document.static-www.json
}