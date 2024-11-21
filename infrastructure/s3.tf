# S3 Bucket
resource "aws_s3_bucket" "storage" {
  bucket = "my-secure-storage-bucket"
}

resource "aws_s3_bucket_versioning" "storage" {
  bucket = aws_s3_bucket.storage.id
  versioning_configuration {
    status = "Enabled"
  }
}