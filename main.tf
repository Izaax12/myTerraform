#### Para esta parte, se estara creando una instancia EC2, con gninx, security groups
#### y tags

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "name" {
    # Amazon image
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t3.micro"

    # Script para instalar nginx
    user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                EOF
    # Pasamos el valor de la llave ssh
    key_name = aws_key_pair.nginx-server-ssh.key_name

    # Asignamos SG
    vpc_security_group_ids = [
        aws_security_group.nginx-server-sg.id
    ]

    tags = {
        Name = "nginx-server"
        Environment = "test"
        Owner = "cosmic geralt"
        Team = "Devops"
        Project = "mine"
    }
}   

# Creamos un  ssh key
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
# ssh user@ip -i priv_key
resource "aws_key_pair" "nginx-server-ssh"{
    key_name = "nginx-server-ssh"
    # Donde esta el archivo 
    public_key = file("nginx-server.key.pub")

    tags = {
        Name = "nginx-server-ssh"
        Environment = "test"
        Owner = "cosmic geralt"
        Team = "Devops"
        Project = "mine"
    }
}

# SG
resource "aws_security_group" "nginx-server-sg" {
    name = "nginx-sever-sg"
    description = "Security group to allow HTTP traffic and SSH"


    # Habilitamos puertos
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        # al poner el 0n significa que acepta todos los puertos
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "nginx-server-sg"
        Environment = "test"
        Owner = "cosmic geralt"
        Team = "Devops"
        Project = "mine"
    }

}

########### outputs ##############

output "server_public_ip" {
    description = "Direccion IP publica de la instancia EC2"
    value = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
    description = "DNS publico de la instancia EC2"
    value = aws_instance.nginx-server.ublic_dns
}