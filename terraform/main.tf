# Security Group

resource "aws_security_group" "server" {
  name        = "server-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# This is not a good practice but i am testing some here 
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "server-security-group"
  }
}



# Instance  1 

resource "aws_instance" "server" {
  ami             = data.aws_ami.ubuntu.image_id
  instance_type   = "t2.micro"
  key_name        = "terraform"
  security_groups = [aws_security_group.server.name]
  user_data       = <<EOF
#!/bin/bash
# Update package index
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
EOF

  tags = {
    "Name" = "CI-Server"
  }
}

resource "aws_eip" "server-eip" {
  vpc = true
  instance = aws_instance.server.id
  
}

# # Instance 2

# resource "aws_instance" "CD-server" {
#   ami             = data.aws_ami.ubuntu.image_id
#   instance_type   = "t2.medium"
#   key_name        = "terraform"
#   security_groups = [aws_security_group.server.name]
#   user_data       = <<EOF
# #!/bin/bash
# # Update package index

# # For Docker Installation
# sudo apt-get update
# sudo apt-get install docker.io -y
# sudo usermod -aG docker $USER && newgrp docker

# # For Minikube & Kubectl
# curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# sudo install minikube-linux-amd64 /usr/local/bin/minikube 

# sudo snap install kubectl --classic
# minikube start --driver=docker


# EOF

#   tags = {
#     "Name" = "CD-Server"
#   }
# }

# resource "aws_eip" "cd-server-eip" {
#   vpc = true
#   instance = aws_instance.CD-server.id
  
# }