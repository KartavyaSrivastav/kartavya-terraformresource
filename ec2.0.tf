provider "aws" {
  region = "ap-south-1" 
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "example" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"             

  
  key_name = "my-key-pair"

  
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, EC2!" > /var/www/html/index.html
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "Terraform-Example-Instance"
  }
}

resource "aws_security_group" "ec2_sg" {
  name_prefix = "example-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-security-group"
  }
}
