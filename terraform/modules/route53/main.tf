#Create subdomain in Route53
resource "aws_route53_record" "domain-main" {
    name = var.domain
    type = "A"
    zone_id = var.hosted_zone_id

    alias {
        name    = var.cloudfront_domain_name
        zone_id = var.cloudfront_hosted_zone_id
        evaluate_target_health = false
    }
}