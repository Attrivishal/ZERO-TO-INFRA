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
  name = var.policy_name

  description = "Policy for developers group"
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
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

# More policy for practice 

resource "aws_iam_policy" "developer_policy" {
  name        = var.policy_name
  description = "Policy for developer user"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::company-bucket/*"
      }
    ]
  })
}


resource "aws_iam_group_membership" "developers_membership" {
  name  = "developers-membership"
  group = aws_iam_group.developers.name

  users = [
    aws_iam_user.developer.name
  ]
}

