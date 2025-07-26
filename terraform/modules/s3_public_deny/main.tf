# Publicアクセス禁止のS3を定義します
resource "aws_s3_bucket" "this" {
  bucket_prefix = var.bucket_prefix
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

#バージョニングの設定
resource "aws_s3_bucket_versioning" "this"{
  # バージョニングを有効にするかどうかのフラグ
  count = var.enable_versioning ? 1 : 0
  # バージョニングを有効にするバケット
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [aws_s3_bucket.this]
}