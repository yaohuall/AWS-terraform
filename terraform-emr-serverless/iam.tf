resource "aws_iam_role" "spark-serverless-jobrun-role" {
  name = "spark-serverless-role"

  tags = {
    Name = "spark-serverless-role"
  }

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "emr-serverless.amazonaws.com"
          }
          Effect = "Allow"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "spark-serverless-s3-policy" {
  name = "spark-serverless-policy"
  role = aws_iam_role.spark-serverless-jobrun-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {

        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::*.elasticmapreduce",
          "arn:aws:s3:::*.elasticmapreduce/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
            "arn:aws:s3:::spark-serverless-bucket",
            "arn:aws:s3:::spark-serverless-bucket/*"
        ]
      }
    ]
  })
}