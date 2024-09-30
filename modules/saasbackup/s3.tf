resource "aws_s3_bucket" "saasbackups_s3_bucket_auto" {
  bucket        = "${var.s3_bucket_auto}"
  force_destroy = false
  tags = {
    Name        = "saasbackups"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "saasbackups_s3_bucket_manual" {
  bucket = "${var.s3_bucket_manual}"
  force_destroy = false
  tags = {
    Name        = "saasbackups"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_versioning" "manual_storage_versioning" {
    bucket = aws_s3_bucket.saasbackups_s3_bucket_manual.id
    versioning_configuration {
        status = "Enabled"
    }
}