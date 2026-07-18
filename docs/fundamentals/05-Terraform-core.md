# ⚙️ Level 1: HCL Fundamentals - Terraform Core (Engine Room)

This is where Terraform stops being "just code" and actually starts building things in the cloud.

---

## 🔌 1. Provider (The Translator)

Provider is the plugin that helps Terraform talk to specific platforms like AWS, Azure, Docker, or GitHub.

### 📝 Real-life Analogy
So basically think of it like a basic translator:
* Suppose I speak English (Terraform).
* AWS speaks French (AWS API).
* The Provider is the translator that converts my English instructions into French so AWS understands me.

### Example:
```hcl
provider "aws" {
  region = "us-east-1" # It tells AWS which region
}

provider "google" {
  project = "my-project" # Tell Google Cloud which project
}
```

---

## 🧱 2. Resource (The Builder)

A resource is anything Terraform creates or manages - like EC2, S3 Bucket, VPC, or IAM Role.

### 📝 Real-life Analogy
Think of a resource like a construction worker building my house:
* One worker builds the walls (EC2 server).
* Another worker builds the garage (S3 Bucket).
* Another builds the foundation (VPC network).

### Example:
```hcl
resource "aws_instance" "web" {
  ami           = "ami123"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "data" {
  bucket = "my-bucket" # This builds a storage bucket
}
```

---

## 🔍 3. Data Source (The Reader)

A data source in Terraform is a way to pull information from external systems or services (such as cloud platforms, APIs, or configuration management tools) and use that data in your Terraform configuration.

In simple words, we can say that:
> **Data source reads existing infrastructure instead of creating it.**

### Example:
First, I'll show you without using a data source (creating the resource):
```hcl
# Configure AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "1st VPC"
  }
}
```

Now let me show you how to use a data source (we don't have to create a new VPC, just find the existing one):
```hcl
# Don't create a new VPC, just find the existing one
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["my-existing-vpc"]
  }
}

# Use the existing VPC ID
resource "aws_subnet" "web" {
  vpc_id = data.aws_vpc.existing.id # ← Using existing VPC
}
```

---

## 📦 4. Module (The Reusable Blueprint)

A module is a reusable package of Terraform code - like a function in a programming language. We can directly reuse these packages in our code without writing the code again and again.

### 📝 Real-life Analogy
* Suppose I need to make Maggie for the first time (write a code).
* I save all the instructions on how to make Maggie (create a module).
* I can use this module (or instructions) to make Maggie many times without writing the instructions again. (reuse the module)

### Example:
```hcl
# Use the pre-built module for a VPC
module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my_vpc"
  cidr = "10.0.0.0/16"
}

# Use the same module again for another VPC
module "another_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "another_vpc"
  cidr = "10.1.0.0/16"
}
```

# State (The Memory)

State is Terraform's memory. It records what resources exists and how they map to our code.

Or in more natural way we can define state like:

State stores the data of resources/services whenever we make any services using Terraform. Basically, it acts as a storage of resources/services.

# Why state is important 
1. REMEMBERING:  It helps us to remember what was created when we ran "terraform apply" command.

2. UPDATING : It also tells what to update and reflects the changes in the state. or we can say that all the changes were reflected in "tf.state" file.

3. DELETING: It also tells what to remove whenever it is not needed helps to remove bugs.

4. DUPLICACY: State prevents terraform form creating duplicates. basically whenever I tried to make any service that is already available with same name, State will not allow terraform to make that again

# Backend

The backend is where terraform stored its "memory" state file. (LOCAL = saved on my computer) AND (REMOTE = saved on the cloud also shared with the team)

# Workspaces

So, Basically workspaces let us use the SAME terraform code for DIFFERENT environments (like Dev, Test, Prod) with each having it's own state filel.

means we don't want have to write the code for all the enviornments. so workspaces makes our work easier.

Let me State it's 3 Main things:

1. One Code, Multiple Environemnts : In easy way we can say we can use one code in multiple environment. 
2. Seperate State files
3. Independent Lifecycles


