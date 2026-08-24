# AWS IAM Role

> **"Trust policy tells us who is allowed to assume the role."**

---

## Table of Contents
1. [What is an IAM Role?](#1-what-is-an-iam-role)
2. [Why do we need IAM Roles?](#2-why-do-we-need-iam-roles)
3. [IAM User vs IAM Role](#3-iam-user-vs-iam-role)
4. [How an IAM Role works](#4-how-an-iam-role-works)
5. [Trust Policy](#5-trust-policy)
6. [Permission Policy](#6-permission-policy)
7. [Trust vs Permission Policy](#7-trust-vs-permission-policy)
8. [Who can assume a Role?](#8-who-can-assume-a-role)
9. [Role assumption flow](#9-role-assumption-flow)
10. [Real-world example](#10-real-world-example)
11. [IAM Role ARN](#11-iam-role-arn)
12. [Role Session](#12-role-session)
13. [Temporary credentials](#13-temporary-credentials)
14. [Common use cases](#14-common-use-cases)
15. [Terraform resource](#15-terraform-resource)
16. [Required arguments](#16-required-arguments)
17. [Optional arguments](#17-optional-arguments)
18. [Attributes](#18-attributes)
19. [Basic Terraform implementation](#19-basic-terraform-implementation)
20. [Verify with terraform plan](#20-verify-with-terraform-plan)
21. [Best practices](#21-best-practices)

---

## 1. What is an IAM Role?

An IAM role is an AWS identity that provides a specific set of permissions to a person, application, or AWS service.

The important thing about a role is that **it is not permanently associated with one person** like an IAM User.

For example: imagine we have a Lambda function that needs to upload images to an S3 bucket.

We have two options here to do this:
1. We can put the AWS keys inside the Lambda function.
2. We can give Lambda permission to assume an IAM role.

But, we use the **2nd Option**. Instead of putting AWS keys inside the Lambda function, we give permission to Lambda to assume the IAM role.

```text
                    Lambda Function
                          │
                   Assume IAM role
                          │ 
                    S3 permissions
                          │
                      S3 Bucket
```

This allows Lambda to access AWS resources without storing long-term credentials inside the application.

Now, there is a valid question that can come in your mind. And it is a very important concept you all should know.

I said that we don't need to give the AWS keys in the Lambda function, we can give the permission to Lambda for assuming its IAM role. 

* **But how does this happen? How does Lambda assume its role directly?**

Here is the truth:
The answer is that **Lambda doesn't assume the role by itself. AWS does it for us automatically.**

So basically, we don't write the code to assume the role. AWS does it for you automatically when the Lambda function starts.

---

## 2. Why do we need IAM Roles?

IAM Roles are mainly used to provide secure and temporary access to AWS resources. 

Suppose an EC2 instance wants to read files from S3.

One approach would be that we can store AWS access keys and secret access keys inside the EC2 server. But this is not a good approach or practice because those credentials are stored for a long time and could be exposed to anyone.

What we do in this case is we create an IAM role:

```text
       EC2
        │
     IAM Role
        │
S3 read Permission 
```

So, here EC2 assumes the role and gets temporary security credentials.
And this is a far safer approach than the 1st one because we do not store the credentials for a long time inside any server or application.

---

## 3. IAM User vs IAM Role

Both User and IAM Role come under IAM identities, but they are used differently.

| IAM User | IAM Role |
| :--- | :--- |
| 1. Usually represents a person or long term identity. | 1. Provides permissions that can be temporarily assumed. |
| 2. Commonly used for human access. | 2. Used for accessing AWS resources. |
| 3. Can have long term credentials. | 3. Uses temporary credentials when assumed. |
| 4. Example: Developer | 4. Example: Lambda Execution role |

* **IAM User** = Represents the identity
* **IAM Role** = Provides an identity that another trusted entity can temporarily assume.

---

## 4. How an IAM Role works

An IAM role has two important concepts:
1. **Trust policy**: Who?
2. **Permission Policy**: What?

```text
                           IAM ROLE
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
               Trust Policy       Permission Policy
                    │                   │
                 "WHO?"              "WHAT?"
                    │                   │
                    ▼                   ▼
           Who can assume it?     What can they do?
```

---

## 5. Trust Policy

A trust policy defines **WHO or WHAT** is allowed to assume the IAM role.
It means for which resources we are making this policy.

The technical term for this is the **trusted principal**.

For example: if we want Lambda to use a role, the trust policy can specify Lambda as a trusted principal.

```text
Trust policy
 Who can assume this Role?
            │
          Lambda
```

---

## 6. Permission Policy

A permission policy defines **what actions** the role is allowed or denied to perform.

Suppose we are talking about the same example: a Lambda wants to read the files in an S3 Bucket. And we want Lambda to use a role, so what permission should Lambda be given to perform on the S3 bucket?

The Permission Policy could be:
* `s3:GetObject`
* `s3:PutObject`

This means what the Role can do is:
* Read S3 bucket.
* Upload files in S3 bucket.

---

## 7. Trust vs Permission Policy

* **Trust Policy**: Who can assume this role?
* **Permission Policy**: What actions are allowed to a role after it is assumed.

---

## 8. Who can assume a Role?

An IAM role can be assumed by:
* **AWS Services** (like EC2, Lambda, ECS, etc.)
* **IAM Users** (in your account or another AWS account)
* **External Users** (federated identities via SAML or Web Identity like Google/Amazon Cognito)

---

## 9. Role assumption flow

Here is the complete flow when a trusted entity wants to assume a role:

```text
   Trusted Entity (e.g., Lambda)
                │
                │ 1. Requests to assume the role (sts:AssumeRole)
                ▼
         AWS Security Token Service (STS)
                │
                │ 2. Checks Trust Policy: "Is this entity trusted?"
                ▼
           Trust Policy
                │
                │ 3. Yes, trusted. STS generates temporary credentials
                ▼
     Temporary Credentials (Access Key, Secret Key, Session Token)
                │
                │ 4. Entity uses credentials to perform actions
                ▼
         Permission Policy
                │
                │ 5. Checks Permission Policy: "Is action allowed?"
                ▼
           AWS Resource (e.g., S3 Bucket)
```

---

## 10. Real-world example

### Example 1: Lambda Uploading Images to S3
Let's use a practical example:
Suppose we have:
```text
 user
   │
 Upload Images
   │
 Lambda function 
   │
 S3 Bucket
```

The Lambda function needs to upload images to S3.

We create:
* **IAM Role**
  * **Trust Policy**: Lambda can assume the role.
  * **Permission Policy**: Lambda can upload objects to S3.

**The Complete Flow:**
```text
Lambda Function
       │
       │ AssumeRole
       ▼
Trust Policy
       │
       │ Lambda is trusted
       ▼
Temporary Credentials
       │
       ▼
Permission Policy
       │
       │ s3:PutObject
       ▼
   S3 Bucket
```

### Example 2: EC2 Calling Lambda
Let's see one more example with the full flow.
Suppose I want an EC2 instance to talk to a Lambda function.

We create:
* **IAM Role**
  * **Trust Policy**: EC2 can assume the role.
  * **Permission Policy**: EC2 can invoke the Lambda function.

**The Complete Flow:**
```text
EC2 Instance
       │
       │ (1) "I need to invoke a Lambda function"
       ▼
AssumeRole
       │
       │ (2) "Can EC2 assume this role?"
       ▼
Trust Policy (EC2)
       │
       │ (3) "Yes, EC2 is trusted."
       ▼
Temporary Credentials
       │
       │ (4) "Here are your temporary keys."
       ▼
Permission Policy (Lambda)
       │
       │ (5) "You have lambda:InvokeFunction permission."
       ▼
Lambda Function
       │
       │ (6) "Lambda invoked successfully!"
```

*See these examples very carefully and try to understand.*

---

## 11. IAM Role ARN

Suppose someone asks you: *"What is the address of your IAM Role?"*

In AWS, every resource has a unique address called **ARN (Amazon Resource Name)**.

The syntax for an IAM Role ARN is:
```text
arn:aws:iam::<account-id>:role/<role-name>
```

For example:
```text
arn:aws:iam::123456789012:role/lambda-s3-upload-role
```

You will need this ARN whenever you want to point another resource to this role.

---

## 12. Role Session

When you assume a role, it does not mean you become the role forever.

AWS creates a **Role Session**.

Think of this like a pass to enter a cinema hall. The pass is only valid for a few hours (by default, 1 hour). Once the session expires, you cannot access the resources anymore. You must ask for a new session.

---

## 13. Temporary credentials

When an IAM Role is assumed, AWS STS (Security Token Service) gives you three temporary credentials instead of long-term keys:
1. **Access Key ID** (starts with `ASIA...`)
2. **Secret Access Key**
3. **Session Token** (which proves you assumed the role)

These credentials expire automatically when your session ends, making it very secure.

---

## 14. Common use cases

Here are the most common situations where we use IAM Roles:
* **AWS Service Access**: Allowing services like EC2 or Lambda to access other resources (e.g., S3, DynamoDB).
* **Cross-Account Access**: Allowing users from Account A to manage resources in Account B without creating a new user in Account B.
* **Identity Federation**: Allowing external users (like active directory users, Google users) to login to AWS console or access AWS services.

---

## 15. Terraform resource

To create an IAM Role in Terraform, we use the resource block:
```hcl
resource "aws_iam_role" "role_name" {
  # Configuration goes here
}
```

---

## 16. Required arguments

To create an `aws_iam_role`, Terraform needs two fundamental things:
1. **`name`** (or `name_prefix`): The name of the role.
2. **`assume_role_policy`**: The Trust Policy (written in JSON format) that defines who is allowed to assume the role.

```hcl
# This is the minimum configuration needed:
resource "aws_iam_role" "example" {
  name               = "example-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
```

---

## 17. Optional arguments

Here are some arguments we can use to customize our role:
* **`description`**: A text explaining what this role does.
* **`tags`**: A map of tags to organize the role.
* **`path`**: The path to the role (e.g., `/system/` or `/application/`).
* **`max_session_duration`**: The maximum session duration in seconds (from 3600 seconds to 43200 seconds).
* **`force_detach_policies`**: If `true`, Terraform will force detaching any policies when deleting the role.

---

## 18. Attributes

After Terraform creates the role, it returns some attributes we can reference in other parts of our code:
* **`arn`**: The Amazon Resource Name (ARN) of the role.
* **`id`**: The name of the role.
* **`unique_id`**: The unique identifier created by AWS.
* **`create_date`**: When the role was created.

For example, we reference the ARN as `aws_iam_role.example.arn`.

---

## 19. Basic Terraform implementation

Let's write a complete code to create an IAM role for a Lambda function to read files from S3.

We need three resources in Terraform:
1. **`aws_iam_role`**: The role itself, with a Trust Policy for Lambda.
2. **`aws_iam_policy`**: The Permission Policy allowing S3 read access.
3. **`aws_iam_role_policy_attachment`**: The resource that binds the permission policy to the role.

Here is how we write it:

```hcl
# 1. Create the IAM Role (with Trust Policy)
resource "aws_iam_role" "lambda_s3_role" {
  name = "lambda-s3-read-role"

  # Trust Policy: Who can assume this role?
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "dev"
    Project     = "zero-to-infra"
  }
}

# 2. Create the Permission Policy (What can the role do?)
resource "aws_iam_policy" "s3_read_policy" {
  name        = "lambda-s3-read-policy"
  description = "Allows Lambda to read objects in S3"

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

# 3. Attach the Permission Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  role       = aws_iam_role.lambda_s3_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}
```

---

## 20. Verify with terraform plan

Before applying, run:
```sh
terraform plan
```

What should you look for?
1. **`aws_iam_role.lambda_s3_role` will be created**: Verify the `assume_role_policy` contains the lambda service principal.
2. **`aws_iam_policy.s3_read_policy` will be created**: Verify the permissions are correct.
3. **`aws_iam_role_policy_attachment.lambda_s3_attach` will be created**: It will connect the role and the policy.

The output will show: `Plan: 3 to add, 0 to change, 0 to destroy.`

---

## 21. Best practices

When working with IAM Roles, always follow these rules:
1. **Principle of Least Privilege**: Give the role only the exact permissions it needs to do its job. Never give `*` (administrator access) to a role unless absolutely necessary.
2. **Always restrict the Trust Policy**: Only allow trusted resources (like specific services or specific account users) to assume the role.
3. **Use Tags**: Always add tags to your roles (like `Environment = "dev"`, `Owner = "TeamName"`) to track resources and billing.
4. **Use unique names**: Do not give generic names to roles, make sure the name clearly explains what the role does.



