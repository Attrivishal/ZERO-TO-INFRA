terraform {

    required_version = ">= 1.0.0"


    required_providers {
        aws = {
            source = "hashicorps/aws"
            version = "~> 6.0"
        }
    }
}