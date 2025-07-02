output "distribution_id" {
  value = aws_cloudfront_distribution.static-www.id
}

output "domain_name" {
  value = aws_cloudfront_distribution.static-www.domain_name
}

output "origin_access_identity" {
    value = aws_cloudfront_origin_access_identity.static-www.cloudfront_access_identity_path
}

output "origin_access_identity_iam_arn" {
  value = aws_cloudfront_origin_access_identity.static-www.iam_arn
}