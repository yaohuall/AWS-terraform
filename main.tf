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
    force_destroy = true
    tags = {
        Name = "My bucket"
        Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "tf_test_bucket_acl" {
    bucket = aws_s3_bucket.tf_test_bucket.id
    acl    = var.acl
}

resource "aws_s3_bucket_versioning" "tf_test_versioning" {
    bucket = aws_s3_bucket.tf_test_bucket.id
    versioning_configuration {
    status = "Enabled"
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {

    bucket = aws_s3_bucket.tf_test_bucket.bucket

    rule {
    id = "outdated"

    filter {
        
        and {
            # subset
            prefix = "/"

            tags = {
                rule = "outdated"
                autoclean = "false"
            }
        }
    }

    status = "Enabled"

    transition {
        days          = 30
        storage_class = "GLACIER"
    }
    }
}
