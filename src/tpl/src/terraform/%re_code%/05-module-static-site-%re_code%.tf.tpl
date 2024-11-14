module "static_website" {
  source  = "../modules/aws-static-website-03"
  providers = {
    aws          = aws
    aws.virginia = aws.virginia
  }

  tld_domain         =  var.tld_domain
  acm_domain_name    = "${var.env_subdomain}.${var.fqn_aws_subdomain}"
  webfront_cname     = "${var.webfront_cname}.${var.env_subdomain}.${var.fqn_aws_subdomain}"
  cdn_domain_aliases =  var.webfront_aliases
  org                = var.org
  app                = var.app
  env                = var.env
  bucket_name        = var.bucket_name

  prefix                  = var.prefix
  response_headers_policy = var.response_headers_policy
  origin_request_policy   = var.origin_request_policy
  cache_policy            = var.cache_policy
  s3_cors_methods         = var.s3_cors_methods
  endpoints               = var.endpoints
}

