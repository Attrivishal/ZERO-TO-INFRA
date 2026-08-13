# Terraform AWS Resources Roadmap

A progressive roadmap for learning Terraform by creating common AWS resources. Complete each level in order, as later resources build on the concepts and infrastructure from earlier levels.

## Level 1 — Basic Resources (Foundation)

Learn Terraform syntax, simple resource blocks, variables, references, and core IAM concepts.

- [x] S3 Bucket
- [x] IAM User
- [x] IAM Group
- [x] IAM Policy
- [x] IAM User Group Membership
- [ ] IAM Role
- [ ] IAM Instance Profile

**Goal:** Learn resource blocks, variables, references, and basic IAM concepts.

## Level 2 — Storage

Learn storage resources and how they relate to compute.

- [ ] EBS Volume
- [ ] EBS Snapshot
- [ ] EFS File System

**Goal:** Understand AWS storage options and their relationship with compute resources.

## Level 3 — Networking (Most Important)

Build the networking foundation that nearly every AWS compute resource depends on.

- [ ] VPC
- [ ] Subnet
- [ ] Internet Gateway
- [ ] Route Table
- [ ] Route Table Association
- [ ] Security Group
- [ ] Network ACL
- [ ] Elastic IP

**Goal:** Understand AWS networking and the dependencies required to run compute resources.

## Level 4 — Compute

Launch and manage servers using the networking knowledge built in the previous level.

- [ ] EC2 Instance
- [ ] Key Pair
- [ ] Launch Template

**Goal:** Provision and configure EC2-based workloads with Terraform.

## Level 5 — Monitoring

Add basic logging and alerting to your infrastructure.

- [ ] CloudWatch Log Group
- [ ] CloudWatch Alarm

**Goal:** Learn how to collect logs and create operational alerts.

## Level 6 — Databases

Provision database networking and a managed relational database.

- [ ] DB Subnet Group
- [ ] RDS Instance

**Goal:** Understand the networking and configuration requirements for RDS.

## Level 7 — Messaging

Learn foundational AWS messaging services.

- [ ] SNS Topic
- [ ] SQS Queue

**Goal:** Build simple publish-and-subscribe and queue-based communication patterns.

## Level 8 — DNS

Manage DNS infrastructure with Terraform.

- [ ] Route 53 Hosted Zone

**Goal:** Create and manage DNS zones and records in AWS.

## Level 9 — Secrets

Store configuration and sensitive values securely.

- [ ] Secrets Manager Secret
- [ ] SSM Parameter

**Goal:** Learn secure configuration and secret-management patterns for AWS workloads.
