variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "Billing mode for the DynamoDB table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PROVISIONED"
}

variable "read_capacity" {
  description = "Read capacity units for the table (required if billing_mode is PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units for the table (required if billing_mode is PROVISIONED)"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "The primary key (partition key) for the table"
  type        = string
}

variable "range_key" {
  description = "The sort key (range key) for the table"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attribute definitions for the table (name and type)"
  type = list(object({
    name = string
    type = string
  }))
}

variable "tags" {
  description = "Tags to associate with the DynamoDB table"
  type        = map(string)
  default     = {}
}