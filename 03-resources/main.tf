# Now we write our first real resource in this file.

resource "aws_s3_bucket" "demo" {
    bucket = var.bucket_name
}