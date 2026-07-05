# 🗂️ Level 1: HCL Fundamentals - Data Types

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
