# AWS IAM USER

## Scenario

Your company hired a new employee. You need to create an IAM user using Terraform.

## Your Task

Following our workflow:

### Understand the service

What is an IAM User?

Why is it used?

### Find the Terraform resource

Search the official Terraform AWS Provider documentation.

### Read the documentation

Find:

- Required arguments
- Optional arguments
- Attributes

### Plan

Which values should be variables?

What should not be hardcoded?

### Code

Create one IAM user.

Use variables where appropriate.

### Test

Run:

```sh
terraform fmt
terraform validate
terraform plan
```

Before running plan, predict what Terraform will do.

1. IAM user is an identity in AWS given to a person or application permission to access AWS resources.

2. terraform resource = "aws_iam_user"

3. what is the minimum thing terraform needs to create the aws_iam_user

   -> name: This is the unique name for the IAM user we are creating. It must be a string of alphanumeric characters and few special characters like=,.@-

   minimal code example:

   ```hcl
   resource "aws_iam_user" "example" {
     name = "gerald"   # This is the only required argument
   }
   ```

   The name is the fundamental identity of the user.

Here are some optional arguments for aws_iam_user

| Argument | what it does | Example |
| --- | --- | --- |
| tags | Add labels to organize and track | `tags = {`<br>`  Environment = "dev"`<br>`}` |
| path | Organize users in folders | `path = "/system/"` |

Quick example:

```hcl
resource "aws_iam_user" "example" {
  name = "Vishal"
  path = "/devops"
  tags = {
    Environment = "dev"
    Team        = "Devops"
  }
}
```

"Optional arguments let you customize the user—like adding tags or organizing them with paths."

## What is IAM Policy?

IAM Policy  is a permission given to the user or group to acces AWS specific resources.

Structure of IAM Policy:

```json
{
  "version" : "2012-10-17",
  "statement" : [
    {
      "Effects": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::my-bucket"
    }
  ]
}
```

| Part | What it means | example |
| --- | --- | --- |
| Effect | What is Allow or Deny | "Alow" or "Deny" |
| Action | Whay action is taken on which resource | "s3:ListBucket" |
| Resource | Which resources we are using? | "arn:aws:s3:::my-bucket" |

## What is the difference between:

1. IAM User
2. IAM Group
3. IAM Policy

-> IAM User:(The Individual) A specific person or application with its own credentials (username,password,access key).

```hcl
resource "aws_iam_user" "vishal" {
  name = "Vishal"
}
```

-> IAM Group:(The collection) is a Collection of users that all inherit the same permissions.

```hcl
resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_user" "vishal" {
  name = "vishal"
}

resource "aws_iam_user" "Khushi" {
  name = "Khushi"
}

#Attach users to group
resource "aws_iam_group_membership" "devs" {
  name  = "dev-membership"
  users = [aws_iam_user.vishal.name, aws_iam_user.khushi.name]
  group = aws_iam_group.developers.name
}
```

-> IAM Policy: (The rule) A document that defines what actions are allowed or denied on which resources.

rules are defined in JSON format.

```json
{
  "version" : "2012-12-17",
  "statement": [
    {
      "Effects": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::my-bucket"
    }
  ]
}
```

## The Relationship (How They Work Together):

Simple Visual:

```text
Company
│
├── IAM Policy: "S3 Full Access" (The Rule)
│       │
│       └── Attached to: (Who gets it?)
│
├── IAM Group: "Developers" (The Collection)
│       ├── Vishal (User) → Gets S3 Full Access
│       └── Priya (User)  → Gets S3 Full Access
│
└── IAM User: "Rahul" (Individual)
            → Gets S3 Full Access (Directly)
```

## If i give you areal life example.

Imagine you are as a DevOps ENgineer of your comapany XYZ.

And your Company has:

10 Developers

Should you give every developer  right to become a admin.

Answer is NO.

Instead of , You create a policy like:

Developers policy:

-> Read S3

-> Read cloudwatch

-> Connect to Ec2

And the policy or permission is given to Developers is:

Delete VPC

Delets RDS

Create IAM Users

Then We attach this policy to the developer group that we had created.

So that each developers automatically gets those permission.

```text
AWS Flow
 IAM User
    │
    ▼
 IAM Group
    │
    ▼
 IAM Policy
    │
    ▼
AWS Resources
```

## some common Optional  arguments for policy when we are making

Like:

1. name
2. description
3. path
4. tags

## what comes under Policy:

what action we are going to take?

Where we taking this action on which resources?

do we allow or deny the action?(Effect)

Policy needs version and statement. under it

Statement is a list [].and one statement is one permission rule.

## Why is Statement a List?

Statement is a list becasue one IAM policy can contanin multiple persmission rules(Statements). Each statement is an independent rule

## Now, What is IAM User Group Membership

first understand what we did till now:-

we currently have two independednt resources:

```text
IAM USER
|-- vishal-attri

IAM GROUp
|--Developers
```

But AWS doesn't know automatically that this user belongs to this group.

We want:

```text
Developers
|-- vishal-attri
```

Like this, So this represents the relationship between the two.

And this an important concept of terraform :

some Terraform resources creates things, While others manages relationship between things.

The Terraform resources which we are looking for?

```hcl
aws_iam_group_membership
```

so the basic structure is:

```hcl
resource "aws_iam_group_membership" "developers_membership"{

}
```

remember that here we are not creating another user and group we're just creating a membership relationship.

What does it need to create?

so, Terraform need two things.

Wich group? we are working on.

developers

Which users? who is the user?

vishal

So here where our previous leanring becomes usefull,

previoulsy when we create the resouces for IAM users and for IAM group

```hcl
resource "aws_iam_user" "developers" {
  name = var.user_name
}

resource "aws_iam_group" "debelopers"{
  name = var.group_name
}
```

so we don't have to write this again, terraform can reference the existing resources.

-> aws_iam_user.developers.name

it means to: vishal-attri

-> aws_iam_group.developers.name

it means to: developers

One new important thing:

user is a list

A group can contain:

1 user

or

100 users

Therefore, the membership resource expects a list of users.

Even we have only a one user:

it still takeit as a list

```text
Users
|- vishal
```

List:

```hcl
[
  "vishal-attri"
]
```

so our resources will have something like this:

```hcl
uses = [
  aws_iam_users.developer.name
]
```

Now think about the group:-

Group itself is just one group:

developers

```hcl
group = aws_iam_group.developer.name
```

So the relationship becomes:

```text
developers
   |
membership
   |
  vishal
```

So the complete resoruce is lool like this:

```hcl
resource "aws_iam_group_membership" "developer_membership"{
  name = "developer-membership"
  group = aws_iam_group.developer.name

  user = [
    aws_iam_user.developer.name
  ]
}
```

## Why do wee need a seperate resource?
 Why can't i just put the USER inside aws_iam_group?

Because AWS treats these as seperate concept.