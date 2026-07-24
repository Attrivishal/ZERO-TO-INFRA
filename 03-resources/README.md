# 🏗️ Terraform Resources: What & Why

## ❓ What is a Resource in Terraform?

So, if we are talking about resources in terraform. This is very important concept in terraform because it helps terraform to create or manage the cloud infrastructure like a server, database or a storage bucket.  
*(Think of it as the blueprint for your cloud components!)*

---

## 🤔 Why do we use this?

Let me tell you with the help of a table.  

| **WITHOUT RESOURCE** ❌ | **WITH RESOURCE** ✅ |
| :--- | :--- |
| You manually click in AWS console. 🖱️ | We just write code here 💻 |
| It takes 10 minutes per server ⏱️ | It takes 10 seconds ⚡ |
| Easy to make mistakes 😰 | It is consistent and repeatable 🔁 |
| Hard to track and manage 🗂️ | Everything is in code 📄 |

---

## 📐 Basic Syntax

```hcl
resource "Type" "name" {
   ARGUMENT1 = "value 1"
   ARGUMENT2 = "value 2"
}
Part Meaning Example
resource It tells terraform "I want to create something" 🛠️ resource
"TYPE" What type of service we want to use, Write here 📦 "Ec2_instance" (EC2 server)
"NAME" Here we defined the service name we describe 🏷️ "web_server"
{ } Here we configure all the details that we discuss above ⚙️ ami = "ami-123"
