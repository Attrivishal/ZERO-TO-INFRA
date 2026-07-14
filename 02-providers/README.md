Some important things that you need to know is that: 
  Please avoid writing hardcoded values directly in your code. instead of hardcoding please varibales that we discussed.

You must have this question that why ?

Because professional engineers avoid hardcoded values.

Suppose Today it's:
 region is = "us-east-1"

And Tomorrow your manager or anyone  says that:

You need tp Deploy the same infrastructure in Mumbai.

If it's hardcoded, you'll edit the code.

If it's a variable, you only change one value.

## Hey listen  Now what I am gonna tell  you is very important concept Please read it carefully.

 If someone ask you that why we write all the configuration in different files instead of one main file "main.tf" And is terraform read files separately?

So the anwers for this question would be like this- 
 
   We separate Terraform code by responsibility to improve readability, maintainability, scalability, and team collaboration. As the infrastructure grows, keeping everything in main.tf becomes difficult to manage. Splitting code into dedicated files allows developers to quickly locate providers, variables, resources, and outputs.
 
 And  terraform does not read all file separately. It read all .tf files in the current directory an merges them into one maain configuration. 

 For example: 
  you wrote two different files of variables.tf and providers.tf
--------------------------------------
  hcl
  provider  "aws"{
    region = "var.aws_reggion"
  }
---------------------------------------
  hcl
  variable "aws_region" {
    default = "us-east-1"
  }

what terraform does here it combine these file in one main file as main.tf

so that's why a variable declared in one file hat can be used in another.