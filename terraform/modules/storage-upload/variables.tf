#Storage variables

variable "html_path" {
  description = "Path to the HTML files"
  type        = string
}

variable "upload_bucket_id" {
  description = "Bucket name"
  type        = string
}

variable "script_js_name" {
  description = "Name api.js"
  type        = string
}

variable "script_jscontent" {
  description = "Content of api.js"
  type        = string
}

variable "cloudfront_oac" {
  description = "Accept cloudfront distribution access"
  type        = string
}