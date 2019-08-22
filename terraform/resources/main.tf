
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "com.jefflong.pipelines"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

output "codepipeline_bucket_output" {
  value = aws_s3_bucket.codepipeline_bucket
}

