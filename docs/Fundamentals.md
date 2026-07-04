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

# 💎 What is values?

> [!NOTE]
> In Terraform, values are the actual data which is stored in the configuration  whether it is in the form of numbers, boolean and characters/text. 
> 
> Always rember this simple formula:
> 
> **------ EVERTHING stored in the Terrafomr = VALUE -------**

For Example: 
* 🔢 **Numbers:** 7,16
* 🚦 **Booleans:** true, false
* 📝 **character/text:** "Vishal", "Hello"

like this:
Wait let me show you a real example: 

```hcl
resource "aws_instance" "web" {
    ami           = "ami123"     # <- value (characters/text)
    instance_type = "t2.micro"   # <- value (characters/text)
    count         = 7            # <- value (Number)
    monitoring    = true         # <- value (Boolean)
}
```

> [!IMPORTANT]
> ### Key rule to remmber guys : 
> **-------- Everything on the right side of = is a VALUE --------**

---

# 🗂️ what is Data Types in Terraform? 

> [!NOTE]
> Data types tell the terraform what KIND of values it is handling, whether it is text, a number, boolean, a list, or something more complex.

---

# 📚 The complete Data Types Reference: 

| # | Data Type | Quick Summary (Your Notes) |
| :-: | :--- | :--- |
| 1 | 🔤 **String** | Text data - always presented in double quotes. |
| 2 | 🔢 **Number** | It contains all numeric values - No quotes |
| 3 | 🚦 **Boolean** | It containe onlt true and false values nothing else - No qoutes |
| 4 | 📋 **List** | It is a collection of array of values (ordered) - defined with [] |

<br>

### 1. String
Text data - always presented in double quotes.

like: 
```hcl
region = "us-east-1"
name   = "Vishal"
ami_id = "ami-0c55b1293"
```

### 2. Number
It contains all numeric values - No quotes

like: 
```hcl
age            = 21
port           = 8080
instance_count = 7
```

### 3. Boolean
It containe onlt true and false values nothing else - No qoutes

like :  
```hcl
enable_dbs          = true
enable_monitoring   = false
is_encrypted        = true
enable_backup       = false 
```

### 4. List
It is a collection of array of values (ordered) - defined with `[]`

like: 
```hcl
servers = ["web","db"]
ports   = [80,443]
enabled = [true,false]


Lists help professionals avoid repeating themselves in Terraform code. They store multiple values of the same type in a specific order, let you access them by position (starting from 0), and work perfectly with features like count and for_each to create resources dynamically. Functions like length(), join(), and contains() make lists even more powerful for writing clean, maintainable infrastructure code.

Quick Professional Reference:

# Declare
instane_names = ["web", "db","app"]

#ACCESS
instance_names[0] # "web" if it is presentin the list 

#LENGTH 
length(instance_names) #3 It counts  character of the word

# LOOP
count = length(instance_names) # create 3 resources

# CHECK 
contains(instance_names, "web") # true

# TRANSFORM 
join (", ", instance_names). # "web, db, app"

```


# Map 

A map is a collection of Key-Value pairs (like dictionary) where each key has a corresponding value

# syntax
  
  {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  }

  Lets see some example of mapping in terraform 

  <!-- map of string -->
   person = {
    Name = "Vishal"
    City = "Delhi"
    Job = "Devops Engineer"
   }

  <!-- map of numbers -->
   scores = {
    Math = 99
    science = 98
    English = 100
   }

   <!-- map with different types -->
   config = {
    region = "us-east-1"
    port = 8000
    is_secue = true
   }

Let me show you a analogy:

The ID Card Analogy:
  ID Card : {
    Name : "Vishal"
    Age : 21
    City : "New Delhi"
    Married : false
  }

Key (field)               value (information)
Name                          "Vishal"
Age                             21
City                          "New Delhi"
Married                        false

# Object in Terraform

Object is a collection of data but it stores data only when  the correct data-type is matched , it does not stored that data which is not comes under thier data-type

    for example: 
       Suppose I am write Name : 22 
         so this is wrong here , we can only write  string type of data here, in Name column. so it can match it's own dataype type which is "string".


object is tightly structured with its own data-type. 


# Components
Components are notes we write to explain what we are going to in the code or which service we are writing this code for.


For example: 
    # creating a ec2 server for website
      resource "aws_instance" "web" {
        #....
      }


    # creating a s3 Bucket for storing 
    resource "aws_s3_bucket" "data"{
      #...
    }

Basically, components are the comments which we are using in our code.  