# Now we write our  real resource in this file.
resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name
}

# IAM user
resource "aws_iam_user" "developer" {
  name = var.user_name
}

# IAM Group
resource "aws_iam_group" "developers" {
  name = var.group_name
}

# IAM Policy
resource "aws_iam_policy" "developers_policy" {
  name        = var.policy_name

  description = "Policy for developers group"
  policy = jsonecode({
    version = "2012-10-17"

    statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]

        Resource = "*"
      }
    ]
  })
}

