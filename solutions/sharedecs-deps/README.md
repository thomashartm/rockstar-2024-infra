# Shared Dependencies 

## Cloudfront Authorization
This setup uses a cloudfront function to enforce authentcated access to the cloudfront distribution and any underlying 
resource.
The credentials are managed via a cloudfront keyvalue store which must be associated manually to the function
because as by now terraform does not support the propagation of values to the cloudfront keyvalue store or
the association with a function.

Please checl the following resources for more information:

    resource "aws_cloudfront_function" "cloudfront_secure_access" {
      name    = "chataem_cloudfront_httpauth_access"
      runtime = "cloudfront-js-2.0"
      code    = file("function/index.js")
      comment = "Cloudfront function to secure access to the website"
    }

    resource "aws_cloudfront_key_value_store" "function_key_value_store" {
      name    = "chataem_cloudfront_httpauth_access"
      comment = "Key value store which stores the config for the cloudfront function"
    }

The key must be named basicAuthKey  and the value a combination of username and password separated by a colon and base64 encoded.
Please replace the kvsId value with your own:

    const kvsId = '<your key>';
