

resource "aws_iam_policy" "s3_offsite_replication" {
  name        = "s3_offsite_replication"
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
            "s3:ReplicateTags",
            "s3:ObjectOwnerOverrideToBucketOwner"
         ],
         "Resource":"${aws_s3_bucket.saasbackups_s3_offsite.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "offsite_s3_replication" {
  bucket = aws_s3_bucket.saasbackups_s3_bucket_manual.bucket
  role = aws_iam_role.s3_offsite_replication_role.arn
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

resource "aws_iam_role" "s3_offsite_replication_role" {
  name               = "s3_offsite_replication_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_offsite_replication_attach" {
  role       = aws_iam_role.s3_offsite_replication_role.name
  policy_arn = aws_iam_policy.s3_offsite_replication.arn
}

resource "aws_s3_bucket" "saasbackups_s3_offsite" {
  provider = aws.backup
  bucket = "${var.s3_bucket_manual}-offsite"
  force_destroy = false 
  tags = {
    Name = "saasbackups"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_versioning" "offsite_storage_versioning" {
    provider = aws.backup
    bucket = aws_s3_bucket.saasbackups_s3_offsite.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_policy" "destination_repliction_policy" {
  bucket = aws_s3_bucket.saasbackups_s3_offsite.id
  provider = aws.backup
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForDestinationBucket"
    Statement = [
      {
        Sid       = "Permissions on objects"
        Effect    = "Allow"
        Principal = {
          AWS = "${aws_iam_role.s3_offsite_replication_role.arn}"
        }
        Action    = [
          "s3:ReplicateTags",
          "s3:ReplicateDelete",
          "s3:ReplicateObject",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource  = "${aws_s3_bucket.saasbackups_s3_offsite.arn}/*"
      }
    ]
  })
}
