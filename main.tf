#### Para esta parte, se estara creando una instancia EC2, con gninx, security groups
#### y tags

# Variables
variable "ami_id"{
    description = "ID de la AMI para la instania EC2"
    default = "ami-0440d3b780d96b29d"
}

variable "instance_type"{
    description = "Tipo de instancia EC2"
    default = "t3.micro"
}

variable "server_name" {
    description = "Nombre del servidor web"
    default = "nginx-server"
}

variable "environment"{
    description = "Ambiente de la Aplicacion"
    default = "test"
}

provider "aws" {
  region = "us-east-1"
}

# Instancia EC2
resource "aws_instance" "nginx-server" {
    # Amazon image
    # ami = "ami-0440d3b780d96b29d"
    # instance_type = "t3.micro"

    ami = var.ami_id
    instance_type = var.instance_type

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
        # Name = "nginx-server"
        Name = var.server_name
        # Environment = "test"
        Environment = var.environment
        Owner = "cosmic geralt"
        Team = "Devops"
        Project = "mine"
    }
}   

# Creamos un  ssh key
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
# Si se requiere crear mas de 2 servers, se tienen que crear sus llaves
# correspondientes
# ssh user@ip -i priv_key
# concatenamos valor de vars: ${var.server_name} entre comillas
resource "aws_key_pair" "nginx-server-ssh"{
    key_name = "${var.server_name}-ssh"
    # Donde esta el archivo 
    public_key = file("${var.server_name}.key.pub")

    tags = {
        Name = "${var.server_name}-ssh"
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
    value = aws_instance.nginx-server.public_dns
}