resource "aws_kms_key" "key" {
 description             = "This key is used to encrypt database"
 deletion_window_in_days = 30
 enable_key_rotation     = false

 lifecycle {
    prevent_destroy = true
  }
  
}

resource "aws_kms_alias" "key-alias" {
 name          = var.aws_kms_alias_name
 target_key_id = aws_kms_key.key.key_id
}