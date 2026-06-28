Level 1: HCL Fundamentals
This is the foundation of Terraform

without this, you will only be copying code from tutorials.

1 Blocks : 
  -> What is a Block?
  Ans. A  Block is a basic building unit of terraform 
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

Real-life Analogu 

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

    