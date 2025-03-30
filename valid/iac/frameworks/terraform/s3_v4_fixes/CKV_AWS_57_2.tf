resource "aws_s3_bucket" "bad_bucket" {
  bucket = "bad_bucket"
  acl = "public-read-write"
}