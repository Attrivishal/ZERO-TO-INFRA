variable "aws_region" {
  description = "AWS REGION"
  type        = string
}

variable "bucket_name" {
  description = "Attri-bucket"
  type        = string
}

variable "user_name" {
  description = "IAM user name"
  type        = list(string)
}

variable "group_name" {
  description = "IAM group name"
  type        = list(string)
}

variable "policy_name" {
  description = "IAM policy name"
  type        = string
}



# EBS Volume Variables

variable "ebs_volume_size" {
  description = "Size of the volume"
  type        = number
}

variable "ebs_volume_type" {
  description = "EBS Volume type"
  type        = string
}

variable "ebs_availability_zone" {
  description = "Availability Zone for the EBS Volume"
  type        = string
}

variable "ebs_encrypted" {
  description = "Whether the EBS volume should be encrypted"
  type        = bool
}
