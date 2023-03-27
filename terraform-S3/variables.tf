variable "region" {
    description = "AWS region"
    default = "us-east-2"
    type = string
}

variable "bucket_name" {
    description = "AWS S3 bucket name"
    default = "test-bucket"
    type = string
}

variable "acl" {
    description = "S3 acl policy"
    default = "private"
    type = string
}