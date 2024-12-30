variable "bucketname" {
  description = "Name for the bucket"
  type        = string
}

variable "bucket_tags" {
  description = "Tag definition for the bucket"
  type        = map(string)
}

variable "html_path" {
  description = "Path to the HTML files"
  type        = string
}