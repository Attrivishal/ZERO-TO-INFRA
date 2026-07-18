# Let's Understand This

Most tutorials say:
> This is the terraform block.
> End.

No. Let's go deeper.

---

## Question 1

Why did we write:
```hcl
terraform {

}
```
instead of:
```hcl
Terraform {

}
```

### Answer:
Terraform keywords are case-sensitive. Only `terraform` is valid.

---

## Question 2

Why no quotes?

We wrote `terraform` not `"terraform"`.
Why?
Because `terraform` is a keyword.
Keywords are never inside quotes.

Exactly like:
* Java: `class`
* Python: `if`
* C: `int`

---

## Question 3

Why curly braces?
```hcl
terraform {

}
```
Because everything belonging to the terraform block goes inside.

Think:
```
School
  ↓
Students
  ↓
Teachers
  ↓
Rooms
```
The School contains everything.

Similarly:
**Terraform Block** contains **Terraform Settings**.

---

## Question 4

Can there be two terraform blocks?

### Example:
```hcl
terraform {

}

terraform {

}
```

### Interesting question:
Terraform merges compatible settings, but some settings can only be declared once. In practice, you'll almost always use one terraform block per root module because it keeps the configuration clear and avoids conflicts.

---

## Internal Working

When Terraform starts, it scans every `*.tf` file.
Then it searches for `terraform` block.

Why?
Because Terraform first needs to know:
* Which version?
* Which providers?
* Backend?
* Experiments?

Only then it reads resources.

---

# Three things that will eventually goes insiide the terrafotm block 

* `required_versions`
* `required_providers`
* `backend`

More concepts will come in this file.