AWS IAM USER
Scenario
Your company hired a new employee. You need to create an IAM user using Terraform.

Your Task
Following our workflow:
Understand the service
What is an IAM User?
Why is it used?
Find the Terraform resource
Search the official Terraform AWS Provider documentation.
Read the documentation
Find:
Required arguments
Optional arguments
Attributes
Plan
Which values should be variables?
What should not be hardcoded?
Code
Create one IAM user.
Use variables where appropriate.
Test
Run:
terraform fmt
terraform validate
terraform plan
Before running plan, predict what Terraform will do.

1. IAM user is an identity in AWS given to a person or application permission to access AWS resources.

2. terraform resource = "aws_iam_user"

3. what is the minimum thing terraform needs to create the aws_iam_user

   -> name: This is the unique name for the IAM user we are creating. It must be a string of alphanumeric characters and few special characters like=,.@- 

    minimal code example:
      hcl
       resource "aws_iam_user" "example" {
        name = "gerald"   # This is the only required argument 
       }
    The name is the fundamental identity of the user.

Here are some optional arguments for aws_iam_user
 
 Argument         what it does                      Example
 tags            Add labels to organize and track    tags = {
    Environment = "dev"
 } 
 path            Organize users in folders           path = "/system/"

 Quick example:
  hcl
  resource "aws_iam_user" "example" {
    name = "Vishal"
    path = "/devops"
    tags = {
        Environment = "dev"
        Team        = "Devops"
    }
  }

 "Optional arguments let you customize the user—like adding tags or organizing them with paths."

 