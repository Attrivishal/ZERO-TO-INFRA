# This file contains the terraform version and required providers.

terraform {
  required_version =">= 1.8"

  required_providers {
    aws = {
      source = " hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

