output "cloudfront_oac" {
  description = "The public ID of the S3 bucket"
  value       = data.aws_iam_policy_document.cloudfront_oac.json
}

output "domain_name" {
  description = "The public ID of the S3 bucket"
  value       = aws_cloudfront_distribution.main-cloudfront.domain_name
}

output "hosted_zone_id" {
  description = "The public ID of the S3 bucket"
  value       = aws_cloudfront_distribution.main-cloudfront.hosted_zone_id
}
