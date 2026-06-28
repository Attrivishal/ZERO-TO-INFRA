Level 1: HCL Fundamentals
This is the foundation of Terraform

without this, you will only be copying code from tutorials.

1 Blocks :
-> What is a Block?
Ans. A Block is a basic building unit of terraform

- Everything in Terraform start with a block.
- Think of a block as a conatiner that tells Terraform what you want to configure.

Example.
</>hcl
provoder "aws" {
region = "ap-south-1"
}

Here :
provider is the block.

Another example :
</>hcl
resource "aws_insatnces" "web" {

    }

Again:
resource is the Block.

Real-life Analogy

imagine you're filling out a form :

Personal Detials :

Name :
Age :
Address :

"Personal Details" is the section

Similarly :

provider
resource
variable
module

are sections

Terraform reads each section seperatly.

Common Blocks :

1.  terraform
2.  resources
3.  variable
4.  output
5.  locals
6.  module
7.  data

we almost these common blocks everywhere.

-> Now let's Discuss about Arguments.

-> Inside every block there are arguments

What is arguments?
Ans. Arguments are those which gives information to the block

Example:

    provider "aws" {
        region = "us-east-1"
    }

So, Here region is the argument
think of it like this:
Name = Vishal Attri (Your name)
Age = 21 (Your Age)
City = (Delhi) (Your City)

Every thing in the form
Key = value
is an argument
Basically Everything inside a block is an argument
