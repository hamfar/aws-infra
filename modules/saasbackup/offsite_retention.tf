
resource "aws_iam_policy" "s3_offsite_retention" {
  name        = "s3_offsite_retention"
  description = "Offsite replication of s3 buckets"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
         "Effect":"Allow",
         "Action":[
            "s3:GetObjectVersionForReplication",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectVersionTagging"
         ],
         "Resource":[
            "${aws_s3_bucket.saasbackups_s3_bucket_manual.arn}/*"
         ]
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:ListBucket",
            "s3:GetReplicationConfiguration"
         ],
         "Resource":[
            "${aws_s3_bucket.saasbackups_s3_bucket_manual.arn}"
         ]
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags"
         ],
         "Resource":"${aws_s3_bucket.saasbackups_s3_offsite.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "offsite_s3_replication" {
  bucket = aws_s3_bucket.saasbackups_s3_bucket_manual.bucket
  role = aws_iam_role.s3_offsite_retention_role.arn
  rule {
      id     = "replication_rule"
      status = "Enabled"
      filter {
        prefix = ""
      }
      destination {
        bucket        = aws_s3_bucket.saasbackups_s3_offsite.arn
        storage_class = "DEEP_ARCHIVE"
      }
      delete_marker_replication {
        status = "Enabled"
      }
    }
}


resource "aws_iam_role" "s3_offsite_retention_role" {
  name               = "s3_offsite_retention_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_offsite_retention_attach" {
  role       = aws_iam_role.s3_offsite_retention_role.name
  policy_arn = aws_iam_policy.s3_offsite_retention.arn
}

resource "aws_s3_bucket" "saasbackups_s3_offsite" {
  provider = aws.backup
  bucket = "${var.s3_bucket_manual}-offsite"
  force_destroy = false 
  tags = {
    Name = "saasbackups"
    Environemnt = "${var.environment}"
  }
}

resource "aws_s3_bucket_versioning" "offsite_storage_versioning" {
    provider = aws.backup
    bucket = aws_s3_bucket.saasbackups_s3_offsite.id
    versioning_configuration {
        status = "Enabled"
    }
}