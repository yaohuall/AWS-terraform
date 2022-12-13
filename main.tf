terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

#Resource to create s3 bucket
resource "aws_s3_bucket" "tf_test_bucket" {
  bucket = "yaohua-tf-test-bucket"
}

resource "aws_s3_bucket_acl" "tf_test_bucket_acl" {
  bucket = aws_s3_bucket.tf_test_bucket.id
  acl    = var.acl
}


