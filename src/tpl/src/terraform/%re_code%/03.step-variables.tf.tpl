variable "fqn_aws_subdomain" {
  type        = string
  description = "The aws hosted zone in Route53 domain name."
}

variable "env_subdomain" {
  type        = string
  description = "The subdomain to create internal DNS and append to fqn_aws_subdomain."
}

variable "webfront_cname" {
  type        = string
  description = "The static site webfront CNAME"
  default     = "webfront"
}

variable "webfront_aliases" {
  type        = list(string)
  description = "The aliases which CloudFront replies to"
}

variable "prefix" {
  type = string
  description = "ID for cloudfront policies, used when there's more than one CF distribution per account"
  default = ""
}

variable "endpoints" {
  type = list
  description = "the endpoints to allow connection"
  default = []
}

variable "response_headers_policy" {
  type = bool
  description = "either to enable response_headers_policy"
  default = true
}

variable "origin_request_policy" {
  type = bool
  description = "either to enable origin_request_policy"
  default = true
}

variable "cache_policy" {
  type = bool
  description = "either to enable cache_policy"
  default = true
}

variable "s3_cors_methods" {
  type = list
  description = "additional s3 cors"
  default = ["PUT", "POST"]
}

variable "bucket_name" {
  type        = string
  description = "the name of the s3 bucket to hold webfront files"
}

variable "tld_domain" {
  type = string
  description = "the top level not dependant on the context"
  default = ""
}

