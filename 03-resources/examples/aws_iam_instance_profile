# IAM Instance Profile

### 1. What is an IAM Instance Profile?

An IAM Instance Profile is a container that allows an EC2 instance to use an IAM Role.

I know you guyzz are thinking that Why IAM Instance profile allow Ec2 to use An IAM role. Because Ec2 Instance Can not use Iam role directly. The instance profile is the connector that allows the role to be attached to the instance. 

```text
EC2
 │
Instance Profile
 │
IAM Role
 │
Permissions
```

## Why do we need it?

Suppose an EC2 instance needs to access an S3 bucket.

Instead of storing AWS keys inside EC2:
`EC2` -> `access keys` -> `S3 bucket`

I use Instance profile, because it attached IAM role with EC2:
`EC2` -> `instance profile` -> `IAM role` -> `S3 bucket`

Actually this allow EC2 store temporary credential and avoid storing AWS credentials long term on server.

## Instance Profile vs IAM Role 

**IAM Role**  
Defines: 
1. Trust policy -> Who can assume role?
2. Permissions -> What role can do?

**Instance Profile**  
Allows:
* EC2 to use that IAM Role. 

So Always remember:

```text
IAM Role
 │
Identity + permissions

Instance Profile
 │
Connects the Role to EC2
```

## Suppose EC2 needs to read files from S3: 

```text
EC2
 │
instance profile
 │
EC2-s3-role
 │
Permission policy
 │
s3:GetObject
 │
S3 Bucket
```

This is how our data flows.

The role might have: 
* **Trust Policy:** EC2 can assume this role
* **Permission policy:** `s3:GetObject` is allowed. 

## Now how do we write Instance profile in Terraform?

Terraform Resource:
```hcl
resource "aws_iam_instance_profile" "developer_profile" {
  name = "developer-instance-profile"
  role = aws_iam_role.developer_role.name
}
```

## The most important arguments in this Instance-Profile

- **name**  
  The name of the instance profile.  
  `name = "developer-instance-profile"`

- **role**  
  Specify the IAM role associated with the instance profile.  
  `role = aws_iam_role.developer_role.name`

I want you to notice one thing here: that we are using Terraform resource reference instead of hardcoding the Role name.

## Terraform Relationship

As I already created IAM Role. So I just need to attach that role with instance profile. 

Like in this way:

```hcl
resource "aws_iam_instance_profile" "developer_profile" {
  name = "developer-instance-profile"
  role = aws_iam_role.developer_role.name 
}
```

This is the visual representation :- 

```text
1. You Create IAM Role
   └── aws_iam_role.developer_role
            │
            │ (has permissions: S3, CloudWatch, etc.)
            ▼
2. You Create Instance Profile
   └── aws_iam_instance_profile.developer_profile
            │
            │ (role = aws_iam_role.developer_role.name)
            ▼
3. Profile Now Contains the Role
   └── developer-instance-profile
            │
            └── Contains: developer_role
```

The Complete Flow :-

```text
Step 1: Create IAM Role (WHO + WHAT permissions)
        │
        ▼
Step 2: Create Instance Profile (CONTAINER)
        │
        │ role = aws_iam_role.developer_role.name
        ▼
Step 3: Attach Instance Profile to EC2
        │
        │ iam_instance_profile = aws_iam_instance_profile.developer_profile.name
        ▼
Step 4: EC2 Now Has the Role's Permissions!
```

Let's see the real working example -

```hcl
# 1. First I Create an IAM Role
resource "aws_iam_role" "developer_role" {
  name = "developer-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"    # ← EC2 can assume this role
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 2. We need to Create an Instance Profile (Container) for attaching that IAM role to ec2.
resource "aws_iam_instance_profile" "developer_profile" {
  name = "developer-instance-profile"
  role = aws_iam_role.developer_role.name    # ← Attach the role
}

# 3. Here I Create an EC2 Instance (Uses the Profile)
resource "aws_instance" "web" {
  ami                  = "ami-0c55b159cbfafe1f0"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.developer_profile.name    # ← Attach profile
}
```

So likewise we can see the complete working of the:  
`IAM role` -> `Instance Profile` -> `EC2`.

## Okay! Listen to me carefully. Here are the some points that you must have to clear about.

1. Instance Profile is mainly used with EC2.
2. It does not contain permissions itself. We need to define them according to our requirements. 
3. The IAM Role contains the permissions.
4. The Instance Profile allows EC2 to use the Role.
5. EC2 can obtain temporary credentials through this mechanism that's why always prefer this instead of hardcoding credentials.

