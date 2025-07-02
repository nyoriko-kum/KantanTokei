resource "aws_s3_bucket_object" "index_page" {
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