locals {
  state_bucket           = "<your state bucket name>"
  default_region         = "eu-central-1"
  # Account name and zone are actually used to allow the creation of multiple environments inside the same AWS account
  # just clone your account or environment folder and update your settings
  account_name           = "test"
  zone                   = "test"
  aws_account_id         = "<replace-me-with-your-account-id>"
  hosted_zone            = "<your hosted zone>"
  cloudfront_domain_name = "<your cf domain>"
  domain_name            = "<your domain name>"
  api_credential_secret  = {
    name        = "<replace-me-with-your-secret-name>"
    description = "API credentials for the chat aem application"
  }
}