resource "aws_kms_key" "s3key" {
  #alias 
  description             = "This key is used to encrypt bucket objects for ${var.env_name}"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}