variable "stage" {
    description = "The stage of the environment"
    default     = "test"
}

variable "stack" {
    description = "The stage of the stack"
    default     = "summitchataem"
}

variable "tags" {
  type          = map(any)
  description   = "Tags associated with the repository"
}