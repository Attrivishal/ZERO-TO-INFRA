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

