## Encryption key
resource "aws_kms_key" "s3_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

## Recordings bucket
resource "aws_s3_bucket" "ghost_backup" {
  bucket = "ux2play-una-recordings"

  # https://github.com/hashicorp/terraform-provider-aws/issues/23888
  lifecycle {
    ignore_changes = [
      server_side_encryption_configuration
    ]
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ux2play_una_recordings" {
  bucket = aws_s3_bucket.ghost_backup.id

  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "ux2play_una_recordings" {
  bucket = aws_s3_bucket.ghost_backup.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_acl" "ux2play_una_recordings" {
  bucket = aws_s3_bucket.ghost_backup.id
  acl    = "private"
}
