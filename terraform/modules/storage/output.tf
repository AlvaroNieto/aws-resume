output "bucket_url" {
  description = "The public URL of the S3 bucket"
  value       = "https://${aws_s3_bucket.s3_staticsite.bucket}.s3.${data.aws_region.current.name}.amazonaws.com"
}

output "bucket_id" {
  description = "The public ID of the S3 bucket"
  value       = aws_s3_bucket.s3_staticsite.id
}

output "bucket_fqdn" {
  description = "The public url of the S3 site"
  value       = aws_s3_bucket.s3_staticsite.bucket_regional_domain_name
}

output "bucketname" {
  description = "The name of the S3 site"
  value       = aws_s3_bucket.s3_staticsite.bucket
}

output "s3_arn" {
  description = "The name of the S3 site"
  value       = aws_s3_bucket.s3_staticsite.arn
}