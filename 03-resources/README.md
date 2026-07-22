## First we are going to see what is resource in terraform and why we use this.

  So,if we are talking about resources in terraform. This is very important concept in terraform because it helps terraform to create or manage the cloud infrastructure like a server, database or a storage bucket.

And, WHy we use this.
   let me tell you with the help of a table.

   WITHOUT RESOURCE                         WITH RESOURCE
   You manually  click in AWS console.      We just write code here
   It takes 10 minutes per server           It takes 10 seconds
   Easy to make mistakes                    It is consistent and repetable
   Hard to track and manage                 Everything is in code.

## Basic Syntax

 hcl
 resource "Type" "name" {
    ARGUMENT1 = "value 1"
    ARGUMENT2 = "value 2"
 }

 Now let's clear this technical terms in easy way.

 Part                     Meaning                                             example
 resource         It tells terraform "I want to create something"           resource
 "TYPE"           What type of service we want to used, Write here         "Ec2_instance" (EC2 server)
 "NAME"           Here we defined the service name we descibe              "web_server"
 {}               Here we configure all the details that we discuss above    ami = "ami-123"

 