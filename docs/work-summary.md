<!-- What is Infrastructure> -->

Before Terraform, first understand what "Infrastructure means".

when you open a website like:
  -> Amazon, Google, Apple 

You only see the frontend of that website. 

Behind the scene there are: 
 . Server
 . Databases
 . Virtual Machines
 . Networks
 . Storage
 . Load Balancer
 . DNS

 All these things are together called "INFRASTRUCTURE"

Example: 

Suppose a company wants host a website. 
 
 They need:
  1. Ec2 Instances
  2. Security groups
  3. Storage (S3 buckets)
  4. VPC
  5. Load Balancer


Now let me tell you how traditional Infrastructure is managed:
 
For Example: 

you need to create a Ec2 Instances, so in traditional infra mangement all the things we done it manually. step-by-step. which takes lot's of time and there is a chance of human error while creating infra manually.

Now see here we creating manuallly:

Go to AWS console
    |
 Click Ec2
    |
 Launch Instance
    |
 Select AMI
    |
 Select Instance type
    |
 Configure Security group
    |
 Create 

And like we do same for all the services. But this is not an idle situation in large production system. this won't there

Problems with manual Infrastructure is :
 1. Time consuming
 2. Human Errors
 3. No Documentation
 4. Difficult Recovery
 5. No Version Control


Now we get to Know about :
INFRASTRUCTURE AS CODE (IaC)

Instead of creating Infrastructure manually.
we can easily write a code. for a particular services that we need to make or create. 

Example: 
    provider "aws"{
        region = "us-east-1"
    }

 like this we can write code. If I explain this code. By-the-way this code is very simple it just showing which provider we are using to make an infrastructure and in which in region. Okay this will that in "us-east-1" we have to create a particular services.

Now you get to know. that IaC is very powerfull and usefull. we dont need to select it manually. we just create our infrastructure in just one click.

<!-- What is IaC? -->
Managing and provisioning the infrastructure using code instead of manual process. 

->  Just remember this definition. <-

Now You all are thinking that why Big companies loves IaC?

1. Consistency : 

  . If you compile Java code with Java 8 vs Java 17, you get different results. 

  . Similarly, if you manually configure servers, you get (Configuration drift)- one server has patches, another doesn't.

  . So IaC ensures:- Every servers is built from the same "source code" (Terraform files), just like computing the same source code produces identical binaries.


2. Automation :

  . Instead of  manually running mvn clean install

  . Using IaC :- It does same for infrastructure you can use Terraform apply which trigger the entire pipeline. which do all the things in order. 

3. Repetability :

    . Like creating a docker image and running multiple containers.

    . You build an image once and run 100 containers from it. You don't rebuild the image for each container.

    . IaC does the same: you just have to write your infrastructure code once, and use workspaces or modules to deploy it on dev,stagging,and prod with just different variable files.








<!-- What is terrafrom providers? -->
 provider is plugin that allows Terraform to communicate with a platform or services.

<!-- Different types of providers: -->
1. Official :-  These Providers are maintained by Hasicorp (The company behind Terraform).
   Example:- .AWS, .AzureRM, . Kubernetes
    provider "aws" {
        region = "ap-south-1"
    }

2. Partner :- These providers are maintained by Terrafrom technology partners rather than Hasicorp
    Exapmle:- .MongoDB Atlas, .Datadog

3. Community :- These providers are maintained and developed by individual developers or the open-source community 
Example:- open-source platform providers


<!-- Easy Way to Remember -->

Official  → Maintained by HashiCorp
Partner   → Maintained by a partner company
Community → Maintained by individual developers/community




