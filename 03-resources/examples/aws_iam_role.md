## ## Now we are talking about AWS IAM Role.

Trust policy tells us who is allowed to assume the role."

IAM Role
│
├── 1. What is an IAM Role?
├── 2. Why do we need IAM Roles?
├── 3. IAM User vs IAM Role
├── 4. How an IAM Role works
├── 5. Trust Policy
├── 6. Permission Policy
├── 7. Trust vs Permission Policy
├── 8. Who can assume a Role?
├── 9. Role assumption flow
├── 10. Real-world example
├── 11. IAM Role ARN
├── 12. Role Session
├── 13. Temporary credentials
├── 14. Common use cases
├── 15. Terraform resource
├── 16. Required arguments
├── 17. Optional arguments
├── 18. Attributes
├── 19. Basic Terraform implementation
├── 20. Verify with terraform plan
└── 21. Best practices

## What is IAM Role?

An IAM role is an AWS identity that provides a specific set of permission to a person, application, or aws service.

The important thing about a role is that is not permanentely associated with one person like IAM User.


For example: imagine we have a lambda function that needs to upload images to an s3 bucket.

We have two otpions here to do this. 
1. We can put the AWS keys inside the Lambda Function.
2. We can give Lambda permission to assume an IAM role.

But, we use @2nd Option. Instead of giving AWS keys inside lambda function. we give permission to lambda to assume IAM role.

                    Lambda Function
                          |
                    Assume IAM role
                          | 
                    S3 permissions
                          |
                    S3 Bucket

This allow lambda to access AWS resources without storing long term credentials isnide the application.

Now there is a valid question that can come in your mind. And it is very important concept you all shoud know this.

 I said that we don't need to give the AWS keys in lambda function, we can give the permission to lambda for assuming it's IAM role. 

--> But do you think How is this happen, how lambda assume it role directly?
 Here is the truth:
 The answer is that Lambda doesn't  assume the role by itself AWS does it for us Automatically

 SO basically we don't write the code to assume the role. AWS does it for you automatically when the lambda function starts.


 ## WHy Do we need IAM Roles?

 IAM Roles are mainly used to provides secure and temporary access to AWS resources. 

 Suppose An Ec2 instance wants to read a files frim s3.

 One apporach would be that we can store AWS access keys and secret acces keys inside the ec2 server But this is not a good aproach or practice because those credentials are store fo long time and could be  exposed to anyn one. 

what we do in this case. we created AN IAM role:

EC2
|
IAM Role
|
S3 read Permission 

So, Here Ec2 assumesthe role and gets temporay security credentials.
And this far safer approach from the 1st one. because we do not store the credentials for long time inside any server or application.

## IAM User And IAM Role?
Both User And IAM comes under IAM identites, But they are used differently.

  IAM User                                               IAM Role
1. Usually represnts a person or long term identity.   1. Providers permission that can be temporarily assumed
2. Commonly used for humans acces.                     2. Used for Acces AWS resources
3. Can have long term credentials                      3. uses temporary credentials when assumed
4. Example: Developer                                  4. Example: Lambda Execution role

IAM User = Represent the identity
IAM Role = Provides an identity that another trusted entity can temporarily assume. 


## How Does an IAM role Work?

