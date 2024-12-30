# AWS Resume

My resume that uses the previous aws proyects into a single one.  

## Services used

    1. S3 to store the files.
    2. CloudFront to deliver the content, change the domain, and provide the HTTPS.
    3. ACM to create the certificate used by CloudFront.
    4. Route 53 to create and manage the domain and DNS.
    5. DynamoDB to store the visits of the resume.
    6. Lambda to update and retrieve the visits of the resume into DynamoDB.
    7. API Gateway to call the Lambda function.


### Input variables 

- `hosted_zone_id` - The hosted_zone_id of the domain. Can get it with aws cli: `aws route53 list-hosted-zones`
- `cert_arn` The arn of the certificate. `aws acm list-certificates` (in the us-east-1 region).
- This variables are inside a file in .terraform that is not being commited. Upon `terraform plan` and `terraform apply` I use `-var-file="varfile.tfvars"`. 