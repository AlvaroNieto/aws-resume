# S3 Static Site + HTTPS with CloudFront

Basic resume that is uploaded to AWS S3 and then accessed via CloudFront for custom domain and SSL certificates. 

## Steps

The steps to take are:

    1. Use the basic S3-staticsite resume
    2. Upload to new bucket
    3. Configure CloudFront
    4. Configure subdomain with Route 53
    5. Comment the process along the way.


## Needed info before deployment

- A domain ready in Route 53
- A certificate ready in ACM in us-east-1

### Input variables 

- `hosted_zone_id` - The hosted_zone_id of the domain. Can get it with aws cli: `aws route53 list-hosted-zones`
- `cert_arn` The arn of the certificate. `aws acm list-certificates` (in the us-east-1 region).