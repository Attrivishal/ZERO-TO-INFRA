![HCL Fundamentals](./images/hcl_banner.png)

# 🧱 Level 1: HCL Fundamentals

This is the foundation of Terraform

> [!IMPORTANT]
> **without this, you will only be copying code from tutorials.**

---

## 📦 1 Blocks

> [!NOTE]
> ### -> What is a Block?
> **Ans.** A Block is a basic building unit of terraform
> * Everything in Terraform start with a block.
> * Think of a block as a conatiner that tells Terraform what you want to configure.

### Example:
```hcl
provider "aws" {
  region = "ap-south-1"
}
```

Here:
* `provider` is the block.

### Another example:
```hcl
resource "aws_instance" "web" {

}
```

Again:
* `resource` is the Block.

---

### # What is resource in Terraform?
A resource defines how we need to create, update, and manage infrastructure

#### Real-life Analogy:
Imagine you're filling out a form:

**Personal Details:**
* Name:
* Age:
* Address:

**"Personal Details"** is the section.

Similarly:
* `provider`
* `resource`
* `variable`
* `module`

are sections.

Terraform reads each section seperatly.

---

### Common Blocks:

| # | Common Blocks (Your Notes) |
| :-: | :--- |
| 1 | `terraform` |
| 2 | `resources` |
| 3 | `variable` |
| 4 | `output` |
| 5 | `locals` |
| 6 | `module` |
| 7 | `data` |

we almost these common blocks everywhere.

---

## 🔑 Arguments

* -> Now let's Discuss about Arguments.
* -> Inside every block there are arguments

> [!TIP]
> ### # What is arguments?
> **Ans.** Arguments are those which gives information to the block

### Example:
```hcl
provider "aws" {
    region = "us-east-1"
}
```

So, Here `region` is the argument.

Think of it like this:
* `Name` = `Vishal Attri` (Your name)
* `Age` = `21` (Your Age)
* `City` = `Delhi` (Your City)

Every thing in the form `Key = value` is an argument. Basically Everything inside a block is an argument.

#### Real-Life Analogy:
Suppose you buy your dream car name **(BMW)**:
The car has its: 
* `color = Black`
* `Engine = Petrol`
* `Transmission = Automatic`
 
These are the properties of the car.

Similarly, Terraform resource have properties called arguments.

---

## 🏷️ Labels

> [!NOTE]
> ### # What is Labels?
> Labels are the unique identifiers that come after a block. Basically they give a unique name or indentity to Our terraform block so that we can refer it later.

### For Example: 
```hcl
Block_type "Label1" "Label2" {
     # Here arguments will come
}
```

```hcl
resource "aws_instance" "web_server"{
   ami = "ami-123"
   instance_type = "t2.micro"
}
```

Now let me Break down all for you so that you can understand it easily:

| Code Segment | Label/Type | Function (Your Notes) |
| :--- | :--- | :--- |
| `resource` | **Block type** | It tells terraform what kind of block this is. |
| `"aws_instance"` | **Label1 (Type)** | It tells which cloud servie we want to use? or using! |
| `"web_server"` | **Label2 (Type)** | Here we decide the name of the the resource how do we recall it. |

<br>

| Label Type | Purpose (Your Notes) |
| :--- | :--- |
| **Label1** | Is used for what type of cloud service we want to use. |
| **Label2** | Is used to give an unique name to that service. |

---

### Main purpose of using Labels is:
#### 1. Unique Identification:
BY using Lables we can uniquely identify the resources that we are using or we can say service.

Like:
```hcl
resource "aws-s3" "Storage_bucket1"{
 #..Arguments...
}
resource "aws-s3" "Storage_bucket2"{
 #..Arguments...
}
resource "aws-s3" "Storage_bucket3"{
 #..Arguments...
}
```

By using this name I can check or use this block in future uniquely without any confusion.
