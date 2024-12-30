terraform {
  backend "s3" {
    bucket         = "terraform-state-alvaronl"
    key            = "cloudfront-s3-staticsite/terraform.tfstate"
    region         = "eu-south-2"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

##Template to file creations
# Define the template file and generate the JavaScript file
data "template_file" "js_template" {
  template = file("templates/api.js.tmpl")
  vars = {
    api_invoke_url = module.api_gateway.api_full
  }
}

resource "local_file" "script_js" {
  content  = data.template_file.js_template.rendered
  filename = "../html/js/api.js"
}

#Define .py
data "template_file" "py_template" {
  template = file("templates/lambda_function.py.tmpl")
  vars = {
    domain_origin = "https://alvaronl.com"
  }
}

resource "local_file" "script_py" {
  content  = data.template_file.py_template.rendered
  filename = "../lambda_function.py"
}

provider "aws" {
  region = "eu-south-2"
}

#Input vars
variable "input_hosted_zone_id" {
  description = "Input the domain hosted zone id"
  type        = string
}

variable "input_cert_arn" {
  description = "Input the generated certificated in ACM"
  type        = string
}

# Main deployment for a site.
module "cloudfront_deploy" {
  source = "./modules/cloudfront"

  domain         = "alvaronl.com"
  regionname     = "eu-south-2" # Set same region as provider
  hosted_zone_id = var.input_hosted_zone_id
  cert_arn       = var.input_cert_arn
  s3origin_fqdn  = module.storage-init.bucket_fqdn
  s3origin_id    = module.storage-init.bucket_id
  s3bucketname   = module.storage-init.bucketname
  s3arn          = module.storage-init.s3_arn

  cloudfront_tags = {
    Name        = "Cloudfront-alvaronl-com"
    Environment = "Testing"
  }

  depends_on = [module.storage-init]
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "VisitCounter-lambda"
  main_key   = "visitor_id"
  tags       = { Environment = "test" }
}
module "storage-init" {
  source = "./modules/storage"

  html_path   = "../html/"
  bucketname = "cloudfront-s3-alvaronlcomsite"
    bucket_tags = {
    Name        = "Cloudfront-alvaronl-com"
    Environment = "Testing"
  }

}

output "bucket_url" {
  description = "The public URL of the S3 bucket"
  value       = module.storage-init.bucket_url
}

module "lambda" {
  source             = "./modules/lambda"
  lambda_name        = "visit_counter_lambda"
  runtime            = "python3.12"
  handler            = "lambda_function.lambda_handler"
  filename           = "../lambda_function.zip"
  role_name          = "lambda_execution_role"
  policy_name        = "DynamoDBAccessPolicy"
  dynamodb_table_arn = module.dynamodb.table_arn
  environment_variables = {
    TABLE_NAME = module.dynamodb.table_name
  }

  depends_on = [local_file.script_py]
}

module "api_gateway" {
  source     = "./modules/api_gateway"
  api_name   = "visit-counter-api"
  path_part  = "visit"
  lambda_arn = module.lambda.lambda_arn
  stage_name = "default"
}

module "s3site-upload" {
  source           = "./modules/storage-upload"
  upload_bucket_id = module.storage-init.bucket_id
  #html_path        = "../html/js"
  html_path   = "../html/"
  script_js_name   = "api.js"
  script_jscontent = data.template_file.js_template.rendered
  cloudfront_oac   = module.cloudfront_deploy.cloudfront_oac
}

module "dns" {
  source = "./modules/route53"

  domain                      = "alvaronl.com"
  hosted_zone_id              = var.input_hosted_zone_id
  cloudfront_domain_name      = module.cloudfront_deploy.domain_name
  cloudfront_hosted_zone_id   = module.cloudfront_deploy.hosted_zone_id

}