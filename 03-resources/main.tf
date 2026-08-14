# Now we write our  real resource in this file.
resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name
}

# IAM user
resource "aws_iam_user" "developer" {
  count = length(var.user_name)
  name  = var.user_name[count.index]
}

# IAM Group
resource "aws_iam_group" "developers" {
  count = length(var.group_name)
  name  = var.group_name[count.index]
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
# resource "aws_iam_policy" "developer_policy" {
#   name        = var.policy_name
#   description = "Policy for developer user"

#   policy = jsonencode({
#     Version = "2012-10-17"

#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "s3:GetObject",
#           "s3:ListBucket"
#         ]
#         Resource = "arn:aws:s3:::company-bucket/*"
#       }
#     ]
#   })
# }

#Membership of users in group
# "[*] returns ALL users from a resource, so every group gets the same list of users—to assign different users, use a map that defines which users belong to which group."

resource "aws_iam_group_membership" "developers_membership" {
  count = length(var.group_name)

  name  = "${aws_iam_group.developers[count.index].name}-membership"
  # "${aws_iam_group.developers[count.index].name}-membership" we use this to create a unique name for each group membership resource based on the group name.
  group = aws_iam_group.developers[count.index].name

  users = aws_iam_user.developer[*].name

}
