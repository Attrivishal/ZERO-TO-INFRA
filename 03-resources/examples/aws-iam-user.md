# AWS IAM USER

## Scenario

Your company hired a new employee. You need to create an IAM user using Terraform.

## Your Task

Following our workflow:

### Understand the service
- What is an IAM User?
- Why is it used?

### Find the Terraform resource
Search the official Terraform AWS Provider documentation.

### Read the documentation
Find:
- Required arguments
- Optional arguments
- Attributes

### Plan
- Which values should be variables?
- What should not be hardcoded?

### Code
- Create one IAM user.
- Use variables where appropriate.

### Test
Run:
```sh
terraform fmt
terraform validate
terraform plan
```

Before running plan, predict what Terraform will do.

---

1. **IAM user** is an identity in AWS given to a person or application permission to access AWS resources.
2. Terraform resource = `"aws_iam_user"`
3. What is the minimum thing Terraform needs to create the `aws_iam_user`?
   - **name**: This is the unique name for the IAM user we are creating. It must be a string of alphanumeric characters and a few special characters like `=`, `,`, `.`, `@`, `-`.

   *Minimal code example:*
   ```hcl
   resource "aws_iam_user" "example" {
     name = "gerald"   # This is the only required argument
   }
   ```
   The name is the fundamental identity of the user.

### Optional Arguments for `aws_iam_user`

| Argument | What it does | Example |
| :--- | :--- | :--- |
| `tags` | Add labels to organize and track | `tags = { Environment = "dev" }` |
| `path` | Organize users in folders | `path = "/system/"` |

*Quick example:*
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

> "Optional arguments let you customize the user—like adding tags or organizing them with paths."

---

## What is IAM Policy?

An **IAM Policy** is a permission given to the user or group to access AWS specific resources.

### Structure of IAM Policy:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::my-bucket"
    }
  ]
}
```

| Part | What it means | Example |
| :--- | :--- | :--- |
| **Effect** | Whether to Allow or Deny | `"Allow"` or `"Deny"` |
| **Action** | What action is taken on which resource | `"s3:ListBucket"` |
| **Resource** | Which resources we are using? | `"arn:aws:s3:::my-bucket"` |

---

## What is the difference between:

1. **IAM User**
2. **IAM Group**
3. **IAM Policy**

- **IAM User (The Individual):** A specific person or application with its own credentials (username, password, access key).
  ```hcl
  resource "aws_iam_user" "vishal" {
    name = "Vishal"
  }
  ```

- **IAM Group (The Collection):** A collection of users that all inherit the same permissions.
  ```hcl
  resource "aws_iam_group" "developers" {
    name = "developers"
  }

  resource "aws_iam_user" "vishal" {
    name = "vishal"
  }

  resource "aws_iam_user" "khushi" {
    name = "Khushi"
  }

  # Attach users to group
  resource "aws_iam_group_membership" "devs" {
    name  = "dev-membership"
    users = [aws_iam_user.vishal.name, aws_iam_user.khushi.name]
    group = aws_iam_group.developers.name
  }
  ```

- **IAM Policy (The Rule):** A document that defines what actions are allowed or denied on which resources. Rules are defined in JSON format.
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::my-bucket"
      }
    ]
  }
  ```

---

## The Relationship (How They Work Together)

### Simple Visual:
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

---

## Real Life Example

Imagine you are a DevOps Engineer at company **XYZ**.

Your company has **10 Developers**. Should you give every developer the right to become an admin?

**Answer is NO.**

Instead, you create a policy for developers:

**Developers policy:**
- Read S3
- Read CloudWatch
- Connect to EC2

And the policy/permissions *NOT* given to developers (restricted actions):
- Delete VPC
- Delete RDS
- Create IAM Users

Then we attach the permitted policy to the "Developers" group that we created. That way, each developer automatically gets those permissions.

```text
AWS Flow:
 IAM User ──> IAM Group ──> IAM Policy ──> AWS Resources
```

### Common Optional Arguments for Policy Creation:
1. `name`
2. `description`
3. `path`
4. `tags`

### What comes under Policy:
- What action we are going to take?
- Where we are taking this action (on which resources)?
- Do we allow or deny the action? (Effect)

> **Note:** A policy needs a `Version` and `Statement` block.
> The `Statement` is a list `[]`, where each statement represents one permission rule.

### Why is Statement a List?
`Statement` is a list because one IAM policy can contain multiple permission rules (statements). Each statement functions as an independent rule.

---

## Now, What is IAM User Group Membership?

Let's first understand what we did so far: we have two independent resources.
```text
IAM USER
└── vishal-attri

IAM GROUP
└── Developers
```

But AWS doesn't automatically know that this user belongs to this group. We want:
```text
Developers
└── vishal-attri
```

To represent the relationship between the two, we use an important concept in Terraform: **some Terraform resources create things, while others manage relationships between things.**

The Terraform resource we are looking for is:
```hcl
aws_iam_group_membership
```

The basic structure is:
```hcl
resource "aws_iam_group_membership" "developers_membership" {
  # ...
}
```

> **Remember:** Here, we are not creating another user or group; we are just creating a membership relationship.

### What does it need to create?
Terraform needs two things:
1. **Which group** are we working on? (`developers`)
2. **Which users** belong to it? (`vishal`)

Here is where our previous learning becomes useful. Previously, when we created the resources for the IAM user and IAM group:
```hcl
resource "aws_iam_user" "developers" {
  name = var.user_name
}

resource "aws_iam_group" "developers" {
  name = var.group_name
}
```
We don't have to hardcode names again. Terraform can reference existing resources:
- `aws_iam_user.developers.name` (resolves to: `vishal-attri`)
- `aws_iam_group.developers.name` (resolves to: `developers`)

### One new important thing:
The `users` argument is a **list**. A group can contain 1 user or 100 users, so the membership resource expects a list of users. Even if you have only one user, you must still provide it as a list:
```text
Users:
└── vishal
```
List representation:
```hcl
[
  "vishal-attri"
]
```
So our resource will look like this:
```hcl
users = [
  aws_iam_user.developer.name
]
```

Now think about the group—the group itself is just one group:
```hcl
group = aws_iam_group.developer.name
```

So the relationship becomes:
```text
developers
    │
membership
    │
  vishal
```

And the complete resource looks like this:
```hcl
resource "aws_iam_group_membership" "developer_membership" {
  name  = "developer-membership"
  group = aws_iam_group.developer.name

  users = [
    aws_iam_user.developer.name
  ]
}
```

### Why do we need a separate resource?
*Why can't I just put the USER inside `aws_iam_group`?*

Because AWS treats these as separate concepts. For example:
- EC2 ── Security Group
- User ── Group
- Route Table ── Subnet
- Policy ── Group

---

## How to Create Multiple Users and Use Them in Code

First, we can create multiple users by writing their values in the `terraform.tfvars` file without hardcoding them in the main file. Whenever we are creating more than 1 user, we use a list so that multiple users come under that list.

For example, in `terraform.tfvars`:
```hcl
user_names = [
  "vishal-attri",
  "khushboo"
]
```

But if you run `terraform plan` at this point, it will not execute. Why? Because we created a list in the `.tfvars` file, but previously we were just using 1 user (a string) in our `variables.tf` file. We need to change the variable type from `string` to `list(string)` in `variables.tf`.

Wait, do you think it will work fine now? It won't. Why?

Let's explain this in an easy way: since we are now using a list of users and updated `variables.tf`, the username reference in our `main.tf` file cannot just fetch the list directly as a single username. To access list values, we need to use index values.

Previously, we used a direct way to fetch a single user (not a list):
```hcl
resource "aws_iam_user" "developers" {
  name = var.user_name
}
```

With a list, we access specific users by index:
```hcl
resource "aws_iam_user" "developer" {
  name = var.user_name[1]
}
```

Running `terraform plan` now will give you the second user listed in the configuration (index `1`). This is how we can use multiple users in Terraform.

---

## Data Flow Diagrams

### Data Flow Diagram (Horizontal / Simple)
```text
terraform.tfvars
│
├── user_name
│      ↓
│   IAM User
│      ↓
│   .name
│      ↓
│
│   Membership
│      ↑
│      ↑
│   .name
│      ↑
│   IAM Group
│      ↑
└── group_name
```

### How the Data Flows:
1. **Step 1:** The `terraform.tfvars` file contains the list of users (`user_name`) and groups (`group_name`) we want to create.
2. **Step 2:** The usernames go into the `aws_iam_user` resource. Terraform creates the users and outputs their names via `.name`.
3. **Step 3:** The group names go into the `aws_iam_group` resource, which creates the groups and outputs their names via `.name`.
4. **Step 4:** The `.name` outputs from both users and groups are passed into the `aws_iam_group_membership` resource, which connects the users and groups together.

```text
  aws_iam_group_membership
│
├── Group: developers
│   └── Users: vishal-attri, khushboo
│
└── Group: testers
    └── Users: vishal-attri, khushboo
```

---

### Detailed Visual Flow Diagram
```text
terraform.tfvars
    │
    ├── user_name: ["vishal", "khushboo"]
    │       │
    │       ▼
    │   IAM User (count=2)
    │       │
    │       ├── user[0].name = "vishal"
    │       └── user[1].name = "khushboo"
    │       │
    │       ▼
    │   [*].name → ["vishal", "khushboo"]
    │       │
    │       ▼
    └───────┼────┐
            │    │
            ▼    ▼
        Membership (count=2)
            │    │
            ▲    ▲
            │    │
    ┌───────┼────┘
    │       │
    │       ▼
    │   IAM Group (count=2)
    │       │
    │       ├── group[0].name = "developers"
    │       └── group[1].name = "testers"
    │       │
    └── group_name: ["developers", "testers"]
```

---

### Flow Diagram Summary
```text
terraform.tfvars
│
├── user_name ────→ IAM User ────→ .name ────┐
│   ["vishal", "khushboo"]                    │
│                                              │
│                                              ▼
│                                         Membership
│                                              ▲
│                                              │
└── group_name ────→ IAM Group ────→ .name ───┘
    ["developers", "testers"]
```
> Users come from `user_name`, groups come from `group_name`, and `aws_iam_group_membership` connects them so that all users are added to their respective groups.





