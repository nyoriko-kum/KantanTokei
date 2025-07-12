variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Force destroy the bucket"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  type    = bool
  default = false
}