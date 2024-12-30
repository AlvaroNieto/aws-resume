variable "domain" {
  description = "Domain or subdomain to use in the deployment. It must exist beforehand"
  type        = string
}

variable "regionname" {
  description = "Region"
  type        = string
}

variable "cloudfront_tags" {
  description = "Tag definition for the bucket"
  type        = map(string)
}

variable "hosted_zone_id" {
  description = "Domain hosted zone id"
  type        = string
  sensitive   = true
}

variable "cert_arn" {
  description = "Generated certificate in ACM-us-east-1"
  type        = string
  sensitive   = true
}

variable "s3origin_fqdn" {
  description = "The public url of the S3 site"
  type        = string
}

variable "s3origin_id" {
  description = "The public ID of the S3 bucket"
  type        = string
}

variable "s3bucketname" {
  description = "The public ID of the S3 bucket"
  type        = string
}

variable "s3arn" {
  description = "The public ID of the S3 bucket"
  type        = string
}

