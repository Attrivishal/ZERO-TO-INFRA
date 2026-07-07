# 📖 ZERO-TO-INFRA Documentation

Welcome to the documentation home! Below is the organized Table of Contents for all the learning guides. 

Click on any link to jump directly to that topic.

---

## 🚀 1. Level 0: Introduction to Infrastructure & IaC
*   **[00-iac-introduction.md](00-iac-introduction.md)**
    *   What is Infrastructure?
    *   Manual vs. Automated Infrastructure Management
    *   Why Big Companies Love Infrastructure as Code (IaC)
    *   Terraform Providers (Official, Partner, and Community)

---

## 🧱 2. Level 1: HCL Fundamentals
A deep dive into HashiCorp Configuration Language (HCL), the syntax powering Terraform.

*   **[01-syntax-basics.md](fundamentals/01-syntax-basics.md)**
    *   Blocks (The fundamental container)
    *   Arguments (Key-value configurations)
    *   Labels (Unique resource identifiers)
    *   Values (Data assignments)
    *   Comments (Code annotations)

*   **[02-data-types.md](fundamentals/02-data-types.md)**
    *   Primitive Types: Strings, Numbers, Booleans
    *   Collection Types: Lists, Maps
    *   Structural Types: Objects
    *   Usage summaries and real-world examples

*   **[03-variables.md](fundamentals/03-variables.md)**
    *   Why use Variables? (DRY principle)
    *   Declaring and Referencing variables
    *   Precedence order of Variable inputs (Defaults, Environment Variables, CLI Flags)
    *   Structuring `variables.tf` files

*   **[04-built-in-functions.md](fundamentals/04-built-in-functions.md)**
    *   Why do we need functions?
    *   String & Collection transformations (`upper`, `lower`, `join`, `length`, `max`)
    *   Practical code examples

*   **[05-Terraform-core.md](fundamentals/05-Terraform-core.md)**
    *   Providers (The Translators)
    *   Resources (The Builders)
    *   Data Sources (The Readers)
    *   Modules (The Reusable Blueprints)

---

## 🔙 Navigation
*   Return to [Root README](../README.md)
