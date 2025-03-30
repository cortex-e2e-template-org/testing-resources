resource "aws_s3_bucket" "bad_bucket" {
  bucket = "bad_bucket"


resource "aws_s3_bucket_acl" "bad_acl" {
  bucket = aws_s3_bucket.bad_bucket.id
  acl    = "public-read-write"
}