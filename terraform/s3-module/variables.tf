variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the S3 bucket on deletion"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Whether to enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "index_document" {
  description = "The name of the index document for the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The name of the error document for the website"
  type        = string
  default     = "error.html"
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}
variable "AWS_ACCT_ID" {
  description = "AWS Account ID"
  type        = string
}