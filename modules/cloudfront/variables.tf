variable "domain" {
  type        = string
  description = "The domain name for the CloudFront distribution"
}

variable "index_document" {
  type        = string
  description = "The index document for the CloudFront distribution"
}

variable "certificate_domain" {
  type        = string
  description = "The domain name for the SSL certificate"
}

variable "origin_domain" {
  type        = string
  description = "The domain name for the origin"
}

variable "function" {
  description = "Cloudfront function config. Use a data element to find it by name. Mandatory properties [function_arn: <value>, event_type: viewer_request]."
  type        = map(string)
  default     = null
}