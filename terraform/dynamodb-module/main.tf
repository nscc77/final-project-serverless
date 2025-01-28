resource "aws_dynamodb_table" "memo-app" {
  name           = var.table_name
  billing_mode   = var.billing_mode

  # Provisioned capacity settings (only when billing_mode is PROVISIONED)
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  # Primary key settings
  hash_key  = var.hash_key
  range_key = var.range_key

  # Attribute definitions
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Tags
  tags = var.tags
}