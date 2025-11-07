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