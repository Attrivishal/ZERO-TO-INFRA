# 🌐 ZERO-TO-INFRA

Welcome to the **ZERO-TO-INFRA** repository, your complete step-by-step guide to mastering Infrastructure as Code (IaC) using Terraform.

This repository is designed to take you from an absolute beginner to an advanced level in provisioning, managing, and structuring cloud infrastructure.

---

## 🗺️ Learning Roadmap

Our learning material is divided into conceptual documentation and hands-on exercises:

### 📖 Documentation (The Reading Corner)
All key concepts, syntax references, and explanations are structured in the [docs/](docs/README.md) directory.
1. [Understanding Infrastructure & IaC](docs/00-iac-introduction.md) — Why IaC exists, manual issues, and Terraform providers.
2. **HCL Fundamentals**:
   * [Blocks, Arguments, Labels & Values](docs/fundamentals/01-syntax-basics.md) — The building blocks of Terraform.
   * [Data Types & Schema Structures](docs/fundamentals/02-data-types.md) — Strings, numbers, lists, maps, and objects.
   * [Variables & Input Precedence](docs/fundamentals/03-variables.md) — Writing dynamic, reusable configurations.
   * [Built-in Functions](docs/fundamentals/04-built-in-functions.md) — Transforming data programmatically.
   * [Terraform Core Engine](docs/fundamentals/05-Terraform-core.md) — Providers, Resources, Data Sources, and Modules.

### 🛠️ Interactive Exercises (The Practical Corner)
Run these step-by-step folders in sequence to apply your knowledge:
* 📁 [01-basics](01-basics/README.md) — Hands-on provider configurations, resources, input variables, and the lifecycle commands (`init`, `plan`, `apply`, `destroy`).
* 📁 [02-state-flow](02-state-flow/README.md) — Understanding Terraform state tracking and configuration flow.
* 📁 [03-modules](03-modules/README.md) — Creating and configuring reusable module blocks.
* 📁 [04-environments](04-environments/README.md) — Structuring separate environments for Development and Production.

---

## 🚀 Getting Started

1. Install Terraform CLI on your system.
2. Clone this repository.
3. Open [docs/README.md](docs/README.md) to review the core concepts.
4. CD into [01-basics/](01-basics/) and follow the instructions in its `README.md` to run your first Terraform workspace.
