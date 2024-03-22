variable "name" {
  type          = string
  description   = "Name of the ecr repository"
}

variable "tags" {
  type          = map(any)
  description   = "Tags associated with the repository"
}

variable "cicd_access_role" {
  type          = string
  description   = "ARN of the cicd user role (e.g. jenkins or github actions) which has access to the ecr repo."
}

variable "user_access_role" {
  type          = string
  description   = "ARN of the user role which has access to the ecr repo."
}

variable "immutable" {
  type          = bool
  description   = "Are image tags mutable or not. True if mutable."
  default       = false
}

variable "scan_on_push" {
  type          = bool
  description   = "Are images scanned whenever they get pushed to the registry."
  default       = false
}

variable "encryption_type" {
  type        = string
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS."
  default     = "AES256"
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key to used to encrypt the container images."
  default     = ""
}

variable "lifecycle_policy" {
  type        = string
  description = "Optional lifecycle policy for the ECR repository."
  default     = ""
}

variable "repository_policy" {
  type        = string
  description = "Optional repository policy for the ECR repository."
  default     = ""
}
