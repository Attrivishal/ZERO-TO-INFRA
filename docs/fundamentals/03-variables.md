# ⚙️ Level 1: HCL Fundamentals - Variables

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
