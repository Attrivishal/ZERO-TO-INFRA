provider "aws" {
    region = "var.aws_region"
}
#Example of Multiple Providers
provider  "docker " {
    host = "unix:///var/run/docker.sock"
}
