# This file contains all variables we are going to use in our Terraform files.

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}