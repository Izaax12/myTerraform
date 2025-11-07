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