#Create the Cloudfront distribution
resource "aws_cloudfront_distribution" "main-cloudfront" {
    enabled     = true
    aliases     = [ var.domain ]
    default_root_object = "index.html"
    is_ipv6_enabled     = true
    wait_for_deployment = true
    price_class         = "PriceClass_100"

    default_cache_behavior {
        allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
        cached_methods  = [ "GET", "HEAD", "OPTIONS" ]        
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        target_origin_id = var.s3bucketname 
        viewer_protocol_policy  = "redirect-to-https"
    }

    origin {
        domain_name = var.s3origin_fqdn
        origin_id   = var.s3origin_id
        origin_access_control_id = aws_cloudfront_origin_access_control.main-acl-cloudfront.id
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn      = var.cert_arn
        minimum_protocol_version = "TLSv1.2_2021"
        ssl_support_method       = "sni-only"
    }
}

#Allow S3 connection
resource "aws_cloudfront_origin_access_control" "main-acl-cloudfront" {
    name = "${var.domain}.accesslist"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}

#Allow Cloudfront OAC to access S3 via IAM policy 
data "aws_iam_policy_document" "cloudfront_oac" {
    statement {
        principals {
            identifiers = [ "cloudfront.amazonaws.com" ]
            type        = "Service"
        }

        actions     = [ "s3:GetObject" ]
        resources   = ["${var.s3arn}/*"]

        condition {
            test    = "StringEquals"
            values  = [ aws_cloudfront_distribution.main-cloudfront.arn ]
            variable = "AWS:SourceArn"
        }
    }
}