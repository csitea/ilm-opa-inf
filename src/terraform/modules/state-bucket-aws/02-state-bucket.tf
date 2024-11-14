# Fix deprecation warning ::: https://github.com/hashicorp/terraform-provider-aws/issues/23103
# 1. creates a key to use for server-side encryption that will rotate every 7 days
resource "aws_kms_key" "state_bucket_key" {
  description             = "Encryption key for s3 bucket."
  deletion_window_in_days = var.kms_deletion_window
  enable_key_rotation     = true

  tags = {
    Name = "${var.bucket_name}"
  }
}


resource "aws_s3_bucket" "remote_state_bucket" {
  bucket        = var.bucket_name
  force_destroy = true


  tags = {
      Name  = "${var.bucket_name}"
  }

}

data "aws_caller_identity" "current" {}



resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.remote_state_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.remote_state_bucket.id}/*"
        Principal = {
          AWS = "${data.aws_caller_identity.current.arn}"
        }
      }
    ]
  })
}




# 2. apply server side encryption using key created above on step 1.
# opting out or configuring inside bucket resource is deprecated
resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_key" {
  bucket = aws_s3_bucket.remote_state_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "aws_s3_bucket_versioning" {
  bucket   = aws_s3_bucket.remote_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_dynamodb_table" "aws_dynamodb_table" {
  name           = var.dynamo_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
