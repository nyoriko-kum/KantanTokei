# Publicアクセス禁止のS3を定義します
resource "aws_s3_bucket" "this" {
  bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}