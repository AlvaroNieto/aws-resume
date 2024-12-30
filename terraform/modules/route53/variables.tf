variable "domain" {
  description = "Domain or subdomain to use in the deployment. It must exist beforehand"
  type        = string
}

variable "hosted_zone_id" {
  description = "Domain or subdomain to use in the deployment. It must exist beforehand"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront Domain or subdomain to use in the deployment. It must exist beforehand"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "Domain hosted zone id"
  type        = string
}