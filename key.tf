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