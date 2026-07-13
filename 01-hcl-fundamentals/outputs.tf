#This file contains the outputs of the resources and modules we are going to use in our terraform files.

output "instance_public_ip" {
    description = "The public IP address of the EC2 Instance."
    value       = aws_instance.web_server.public_ip
}