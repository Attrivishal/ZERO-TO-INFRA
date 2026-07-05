# ⚙️ Level 1: HCL Fundamentals - Built-in Functions

## ⚙️ 9. Built-in Functions

> [!NOTE]
> ### What are Functions?
> **Functions** in Terraform allow you to perform transformations and calculations on data—like converting text to uppercase, joining strings, counting list items, or formatting values.
> 
> They work just like functions in traditional programming languages.

### ❓ Why Do We Need Functions?

| Approach | Explanation |
| :--- | :--- |
| **❌ Without Functions** | You have to manually hardcode or duplicate values, making the configuration rigid and difficult to maintain. |
| **✅ With Functions** | Terraform dynamically processes, formats, and transforms data for you, ensuring consistency and automation. |

---

### 🛠️ Common Functions Reference

Here are some real-world examples of built-in functions in action:

#### 1. String & Collection Functions
* **`upper(string)`**: Converts all characters in a string to uppercase.
* **`lower(string)`**: Converts all characters in a string to lowercase.
* **`join(separator, list)`**: Concatenates a list of strings using a specified separator.
* **`length(list_or_map_or_string)`**: Returns the number of items in a collection or the characters in a string.
* **`max(numbers...)`**: Returns the highest number from a set of numeric values.

#### 📝 Code Examples:

```hcl
# 1. Converting String Case
name_upper = upper("hello") # Returns "HELLO"
name_lower = lower("HELLO") # Returns "hello"

# 2. Joining Lists into a Single String
words        = ["web", "server", "prod"]
result_dash  = join("-", words) # Returns "web-server-prod"
result_under = join("_", words) # Returns "web_server_prod"

# 3. Getting Collection Length (counts the number of elements)
servers = ["web", "db", "app"]
count   = length(servers) # Returns 3

# 4. Finding Maximum Value
highest = max(5, 10, 3) # Returns 10
```
