![HCL Fundamentals](./images/hcl_banner.png)

# 🧱 Level 1: HCL Fundamentals

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

## 🗂️ 5. Data Types

> [!NOTE]
> **Data Types** inform Terraform about what *kind* of values it is handling. This ensures Terraform validates the data correctly and prevents configuration errors.

---

## 📚 6. Data Types Reference

### 📚 Data Types Summary

| # | Data Type | Kind | Quick Summary (Your Notes) |
| :-: | :--- | :--- | :--- |
| **1** | 🔤 **String** | Primitive | Text data - always enclosed in double quotes. |
| **2** | 🔢 **Number** | Primitive | Numeric values (integers or floats) - no quotes. |
| **3** | 🚦 **Boolean** | Primitive | Logical values (only `true` or `false`) - no quotes. |
| **4** | 📋 **List** | Complex (Collection) | An ordered array of values of the same type - defined with `[]`. |
| **5** | 🗺️ **Map** | Complex (Collection) | A collection of key-value lookup pairs - defined with `{}`. |
| **6** | 📦 **Object** | Complex (Structural) | A strictly typed schema-based structure with fixed attributes. |

<br>

### 1. 🔤 String
Text data—always enclosed in double quotes.

```hcl
region = "us-east-1"
name   = "Vishal"
ami_id = "ami-0c55b1293"
```

### 2. 🔢 Number
Numeric values (both integers and decimals)—no quotes.

```hcl
age            = 21
port           = 8080
instance_count = 7
```

### 3. 🚦 Boolean
Logical values that can only be `true` or `false`—no quotes.

```hcl
enable_dbs        = true
enable_monitoring = false
is_encrypted      = true
enable_backup     = false 
```

### 4. 📋 List
An ordered collection (array) of values of the same type, defined using square brackets `[]`.

```hcl
servers = ["web", "db"]
ports   = [80, 443]
enabled = [true, false]
```

Lists help professionals avoid repeating themselves in Terraform code. They store multiple values of the same type in a specific order, let you access them by position (starting from 0), and work perfectly with features like `count` and `for_each` to create resources dynamically. Functions like `length()`, `join()`, and `contains()` make lists even more powerful for writing clean, maintainable infrastructure code.

#### 🛠️ Quick List Reference
```hcl
# Declare a list
instance_names = ["web", "db", "app"]

# Access by index (0-based)
instance_names[0] # Returns "web"

# Get list length (counts the number of elements)
length(instance_names) # Returns 3

# Loop to create multiple resources
count = length(instance_names) # Creates 3 resources

# Check if a list contains a specific value
contains(instance_names, "web") # Returns true

# Transform list to a single string
join(", ", instance_names) # Returns "web, db, app"
```

---

### 🗺️ Map
A collection of key-value pairs (like a dictionary) where each key has a corresponding value.

#### Syntax
```hcl
{
  key1 = "value1"
  key2 = "value2"
  key3 = "value3"
}
```

#### Examples of Maps in Terraform:
```hcl
# Map of strings
person = {
  name = "Vishal"
  city = "Delhi"
  job  = "Devops Engineer"
}

# Map of numbers
scores = {
  math    = 99
  science = 98
  english = 100
}

# Map with mixed types (dynamic values)
config = {
  region    = "us-east-1"
  port      = 8000
  is_secure = true
}
```

#### 🪪 The ID Card Analogy
Think of a map like an ID Card:
```hcl
id_card = {
  name    = "Vishal"
  age     = 21
  city    = "New Delhi"
  married = false
}
```

| Key (Field) | Value (Information) | Type |
| :--- | :--- | :--- |
| `name` | `"Vishal"` | String |
| `age` | `21` | Number |
| `city` | `"New Delhi"` | String |
| `married` | `false` | Boolean |

---

### 📦 Object
An **Object** is a tightly structured collection of data where each attribute must match a predefined schema and data type. Unlike maps which hold uniform values, objects can store mixed data types with strict enforcement.

#### Real Example:
If you define a schema where `name` must be a `string`, writing a number instead will result in a type mismatch error:
```hcl
# Schema expects: { name = string, age = number }
user = {
  name = 22 # ❌ ERROR: Expected a string type for "name"
  age  = 21 #  Correct type (number)
}
```
Objects are tightly structured and ideal for defining complex resource configurations.

---

## 💬 7. Comments

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

---

## ⚙️ 8. Variables

Variables act as dynamic placeholders in Terraform. Instead of hardcoding values directly into resource definitions, we declare them in a central place to make our configurations reusable and adaptable.

### ❓ Why Use Variables?

| Benefit | Explanation / Real-World Advantage |
| :--- | :--- |
| 🔄 **1. DRY (Don't Repeat Yourself)** | Declare a value once, reuse it throughout multiple blocks. |
| ⚡ **2. Easy Updates** | Update the value in one central place, and it propagates across all resources. |
| 🎛️ **3. Environment Flexibility** | Deploy the same codebase across Dev, Test, and Prod with environment-specific variables. |

### 🛠️ Working with Variables

#### Step 1: Declaration
First, define your variable (typically in `variables.tf`):
```hcl
variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
```

#### Step 2: Referencing
Next, use the variable inside your resource configurations using the `var.` prefix:
```hcl
resource "aws_instance" "web" {
  instance_type = var.instance_type # Reference the declared variable
}
```

---

### 📥 Methods to Provide Variable Values

There are multiple ways to supply values to variables, ordered by precedence:

| Source | Command/Syntax Example | Precedence |
| :--- | :--- | :--- |
| 📁 **1. Default Value** | Set directly inside the `variable` block in `variables.tf`. | Lowest |
| 🌐 **2. Environment Variable** | `export TF_VAR_instance_type="t3.large"` | Medium |
| 🖥️ **3. Command Line Flag** | `terraform apply -var="instance_type=t3.large"` | Highest |

---

### 📁 Standard `variables.tf` Structure

Here is a clean, production-ready example of how to structure your variables in a `variables.tf` file:

```hcl
# variables.tf

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}
```