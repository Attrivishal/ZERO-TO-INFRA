# 🧱 Level 1: HCL Fundamentals

This is the foundation of Terraform. Without understanding these concepts, you will only be copying and pasting code from tutorials without knowing how it works.

---

> [!IMPORTANT]
> ### ⚠️ Key Rule
> In HashiCorp Configuration Language (HCL), everything is structured around **Blocks**, **Arguments**, and **Labels**. Master these three concepts, and you will understand any Terraform configuration.

---

## 📦 1. Blocks

> [!NOTE]
> ### What is a Block?
> A **Block** is the basic building unit of Terraform. Think of it as a container that groups related configurations together and tells Terraform what you want to configure.

### 📝 Example 1: Provider Block
```hcl
provider "aws" {
  region = "ap-south-1"
}
```
* **Block type:** `provider` (tells Terraform which cloud or service to connect to).

### 📝 Example 2: Resource Block
```hcl
resource "aws_instance" "web" {
  # Configuration settings go here
}
```
* **Block type:** `resource` (tells Terraform to manage a physical or virtual piece of infrastructure).

> [!NOTE]
> **What is a Resource in Terraform?**
> A resource defines how we need to create, update, and manage infrastructure.

---

### 📋 The "Form" Analogy
Think of writing Terraform configurations like filling out a multi-section application form:

```
┌──────────────────────────────────────┐
│  SECTION: PERSONAL DETAILS  (Block)  │
├──────────────────────────────────────┤
│  Name: Vishal Attri                  │
│  Age: 21                             │
│  City: Delhi                         │
└──────────────────────────────────────┘
```

In Terraform:
* `provider`, `resource`, `variable`, and `module` represent the **Sections** (Blocks) of the form.
* Terraform reads each section individually to construct your infrastructure.

### 🛠️ Common Terraform Blocks
Here are the most common blocks you will write in every project:

| Block Type | Purpose | Example |
| :--- | :--- | :--- |
| **`terraform`** | Configures Terraform settings (e.g., versions, backend states). | `terraform { required_version = ">= 1.5.0" }` |
| **`provider`** | Tells Terraform how to communicate with a cloud platform. | `provider "aws" { region = "us-east-1" }` |
| **`resource`** | Defines a service/infrastructure component to create. | `resource "aws_instance" "web" { ... }` |
| **`variable`** | Declares input values to customize configurations. | `variable "port" { default = 80 }` |
| **`output`** | Exposes output values to print or share with other modules. | `output "ip" { value = aws_instance.web.public_ip }` |
| **`locals`** | Defines local constants for internal use. | `locals { app_name = "frontend" }` |
| **`module`** | References groups of reusable code. | `module "vpc" { source = "./modules/vpc" }` |
| **`data`** | Queries external APIs or existing cloud resources. | `data "aws_ami" "ubuntu" { ... }` |

---

## 🔑 2. Arguments

> [!TIP]
> ### What is an Argument?
> Arguments are the key-value pairs inside a block body that configure the resource properties or settings.

### 📝 Example:
```hcl
provider "aws" {
  region = "us-east-1"  # <-- This is an argument
}
```

Think of it like filling out a form where every entry is a `Key = Value` pair:
* `Name` = `Vishal Attri`
* `Age` = `21`
* `City` = `Delhi`

Basically, everything inside a block is formatted as `key = value`, which is an argument.

### 🏎️ The "Dream Car" Analogy
Imagine you buy your dream car: a **BMW**:

```hcl
resource "car" "my_dream_car" {
  brand        = "BMW"
  color        = "Black"
  engine       = "Petrol"
  transmission = "Automatic"
}
```

* The **car** is the resource.
* **`brand`**, **`color`**, **`engine`**, and **`transmission`** are the **Arguments** (properties) that describe your specific car.

---

## 🏷️ 3. Labels

> [!NOTE]
> ### What are Labels?
> Labels are the unique identifiers that come after the block type. They name and identify the block so that you (and Terraform) can refer to it later in the configuration.

### 🔬 Dissecting Block Syntax
```
resource  "aws_instance"  "web_server"  { ... }
   ▲           ▲               ▲
   │           │               └─ Label 2: Resource Name (User-defined, e.g., web_server)
   │           └───────────────── Label 1: Resource Type (Determined by the provider, e.g., aws_instance)
   └───────────────────────────── Block Type (Tells Terraform what kind of block this is)
```

1. **Block Type:** (`resource`) Defines what kind of construct this is.
2. **Label 1 (Resource Type):** (`"aws_instance"`) Tells Terraform which cloud service we are creating.
3. **Label 2 (Resource Name):** (`"web_server"`) A unique name you assign to this block so you can reference its attributes elsewhere.

---

### 🛡️ Why Labels Matter: Unique Identification
Without labels, Terraform wouldn't know which resource is which. By using unique names for Label 2, we can manage multiple instances of the same resource type:

```hcl
resource "aws_s3_bucket" "storage_bucket_1" {
  bucket = "company-logos-prod"
}

resource "aws_s3_bucket" "storage_bucket_2" {
  bucket = "company-assets-prod"
}

resource "aws_s3_bucket" "storage_bucket_3" {
  bucket = "company-backups-prod"
}
```

> [!TIP]
> Label 2 allows you to reference properties of a specific resource. For example, you can get the ID of bucket 1 using: `aws_s3_bucket.storage_bucket_1.id`
