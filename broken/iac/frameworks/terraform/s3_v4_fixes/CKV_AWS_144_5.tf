resource "aws_s3_bucket" "bad_bucket" {
  bucket   = "bad_bucket"
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.bad_bucket.id

  rule 
    id = "foobar"

    filter {
      prefix = "foo"
    }

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}