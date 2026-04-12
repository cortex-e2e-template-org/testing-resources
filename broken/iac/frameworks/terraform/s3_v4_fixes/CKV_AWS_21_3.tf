resource "aws_s3_bucket" "bad_bucket" {
  bucket = "bad_bucket"
}

resource "aws_s3_bucket_versioning" "bad_versioning" {
  bucket = aws_s3_bucket.bad_bucket.id
  versioning_configuration {
    status = "Disabled"
  
}