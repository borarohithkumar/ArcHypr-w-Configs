# 1. Define the Cloud Provider
provider "aws" {
  region = "ap-south-2"
}

# 2. Define the Firewall (Security Group)
resource "aws_security_group" "termind_sg" {
  name        = "termind-security-group"
  description = "Allow SSH, HTTP, and HTTPS traffic"

  # Allow HTTP (Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (Port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, lock this to your personal IP!
  }

  # Allow node_exporter (Port 9100)
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, lock this to your monitoring server's IP!
  }

  # Allow all outbound traffic (for downloading Docker/Updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Generate a ssh key-pair to login to aws-instance
resource "aws_key_pair" "deployer" {
  key_name   = "termind_api_server"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcepdhhEUIowlRVW2rpE0sGF0yYIAQgE2FdEBHdd3Tk ArcHypr Linux Lappy"
}

# 4. Define the Server (EC2 Instance)
resource "aws_instance" "termind_server" {
  ami           = "ami-024ebedf48d280810" 
  instance_type = "t3.micro"
  
  # YOUR SSH KEY (Crucial so you can log in!)
  key_name      = aws_key_pair.deployer.key_name # Change this to the exact name of your .pem file in AWS
  
  vpc_security_group_ids = [aws_security_group.termind_sg.id]

  # DEFINING THE HARD DRIVE (Storage & Speeds)
  root_block_device {
    volume_size = 30           # 30 GB of storage
    volume_type = "gp3"        # gp3 is the modern standard (faster IOPS than gp2)
    iops        = 3000         # 3000 Baseline IOPS
    throughput  = 125          # 125 MB/s Read/Write speeds
  }

  user_data = <<-EOF
              #!/bin/bash
              
              # 1. Update the server
              apt-get update -y
              
              # 2. Install Docker
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              # 3. Give the ubuntu user permission to use Docker without sudo!
              usermod -aG docker ubuntu
              
              # 4. Pull the AI-Brain from Docker Hub
              docker pull borarohithkumar/termind-api:v2.0
              
              # 5. Run the API on port 8000
              docker run -d -p 8000:8000 --restart always borarohithkumar/termind-api:v2.0
              EOF

  tags = {
    Name = "TerMind-API"
  }
}
