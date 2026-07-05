![HCL Fundamentals](../images/hcl_banner.png)

# 🧱 Level 1: HCL Fundamentals - Syntax Basics

Welcome to the core foundation of Terraform and HashiCorp Configuration Language (HCL).

> [!IMPORTANT]
> **Without mastering these fundamentals, you will only be copying code from tutorials. Understanding HCL is the key to writing professional infrastructure as code.**

---

## 📦 1. Blocks

> [!NOTE]
> ### What is a Block?
> A **Block** is the fundamental building unit of Terraform.
> * Everything in Terraform starts with a block.
> * Think of a block as a container that groups configurations together and tells Terraform what to manage.

### Example:
```hcl
provider "aws" {
  region = "ap-south-1"
}
```
Here, `provider` is the block type.

### Another example:
```hcl
resource "aws_instance" "web" {
  # Arguments go here
}
```
Again, `resource` is the block type.

---

### What is a Resource in Terraform?
A **resource** defines how Terraform creates, updates, and manages physical or virtual infrastructure (such as servers, databases, or networks).

#### 📝 Real-Life Analogy
Imagine you are filling out a physical application form. The form is divided into sections:

**Personal Details:**
* Name:
* Age:
* Address:

Here, **"Personal Details"** is the section header.

Similarly, in Terraform, we divide our configurations into logical sections (blocks) like:
* `provider`
* `resource`
* `variable`
* `module`

Terraform reads and parses each block separately to understand the infrastructure plan.

---

### 🧱 Common Blocks Reference
These are the foundational blocks you will see and use in almost every Terraform configuration:

| # | Block | Purpose | Description (Your Notes) |
| :-: | :--- | :--- | :--- |
| **1** | `terraform` | Configuration Settings | Sets Terraform settings, required provider versions, and state backend. |
| **2** | `provider` | API Communication | Configures the target platform or service API (e.g., AWS, GCP, Kubernetes). |
| **3** | `resource` | Infrastructure Component | Declares an infrastructure component to build and manage (e.g., EC2, VPC, S3). |
| **4** | `variable` | Input Parameters | Declares inputs to customize the configuration dynamically without changing code. |
| **5** | `output` | Output Parameters | Exposes resource details (like IP addresses) to the CLI or other modules. |
| **6** | `locals` | Local Variables | Defines temporary, calculated internal variables within a module. |
| **7** | `module` | Reusable Code | Groups multiple resources into reusable configuration packages. |
| **8** | `data` | Read-only Queries | Queries external APIs/providers to fetch information about existing resources. |

---

## 🔑 2. Arguments

Inside every block, we define arguments to specify the configuration details.

> [!TIP]
> ### What is an Argument?
> **Arguments** are key-value pairs inside a block that supply configuration details and values to that block.

### Example:
```hcl
provider "aws" {
  region = "us-east-1"
}
```
Here, `region` is the **argument key** and `"us-east-1"` is the **argument value**.

Think of it like this:
* `Name` = `"Vishal Attri"`
* `Age`  = `21`
* `City` = `"Delhi"`

Everything in the form of `Key = Value` inside a block is an argument.

#### 🚗 Real-Life Analogy
Suppose you buy your dream car—a **BMW**:
The car has several properties (arguments) that describe it:
* `color = "Black"`
* `engine = "Petrol"`
* `transmission = "Automatic"`

These properties define the characteristics of your car. Similarly, Terraform resources have properties called **arguments**.

---

## 🏷️ 3. Labels

> [!NOTE]
> ### What is a Label?
> **Labels** are identifiers that follow the block type. They define the type and name of the resource, giving it a unique identity so that we can reference it elsewhere in our code.

### Syntax Structure:
```hcl
block_type "label1" "label2" {
  # Arguments go here
}
```

### Real Example:
```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-123"
  instance_type = "t2.micro"
}
```

Let's break down this resource block:

| Code Segment | Element Type | Function / Meaning |
| :--- | :--- | :--- |
| `resource` | **Block Type** | Tells Terraform what kind of block this is. |
| `"aws_instance"` | **Label 1 (Type)** | Identifies the cloud service resource class we want to manage. |
| `"web_server"` | **Label 2 (Name)** | The local, user-defined name we give this resource to reference it in code. |

<br>

| Label Level | Target | Purpose (Your Notes) |
| :--- | :--- | :--- |
| **Label 1 (Type)** | Cloud/SaaS resource type | Identifies which cloud service we are interacting with. |
| **Label 2 (Name)** | Local resource identifier | Gives a unique local name to that resource instance. |

---

### Main Purposes of Using Labels:
#### 1. Unique Identification
Using unique labels is essential because it allows us to manage multiple resources of the same type without naming collisions:

```hcl
resource "aws_s3_bucket" "storage_bucket1" {
  # Arguments...
}

resource "aws_s3_bucket" "storage_bucket2" {
  # Arguments...
}

resource "aws_s3_bucket" "storage_bucket3" {
  # Arguments...
}
```
By using these unique names, we can reference or manage each block individually without confusion (e.g., referencing them as `aws_s3_bucket.storage_bucket1`).

---

## 💎 4. Values

> [!NOTE]
> In Terraform, **values** represent the actual data assigned to arguments within a block.
> 
> Always remember this simple rule:
> **Everything stored or assigned in Terraform config files is a Value.**

### Common Types of Values:
* 🔢 **Numbers:** `7`, `16`
* 🚦 **Booleans:** `true`, `false`
* 📝 **Strings/Characters:** `"Vishal"`, `"Hello"`

### Practical Example:
```hcl
resource "aws_instance" "web" {
  ami           = "ami123"     # <- Value (String)
  instance_type = "t2.micro"   # <- Value (String)
  count         = 7            # <- Value (Number)
  monitoring    = true         # <- Value (Boolean)
}
```

> [!IMPORTANT]
> **Golden Rule:** Everything to the right of the assignment operator (`=`) is a **VALUE**.

---

## 💬 5. Comments

Comments are annotations that we write in our code to describe resources, configurations, or explain operational decisions. Terraform ignores them during planning and execution.

### Example:
```hcl
# Creating an EC2 instance for the website frontend
resource "aws_instance" "web" {
  # Arguments go here...
}

# Creating an S3 bucket for storing database backups
resource "aws_s3_bucket" "data" {
  # Arguments go here...
}
```
Basically, comments are our way of annotating and keeping the code readable.
