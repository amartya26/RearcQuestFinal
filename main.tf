#Sepcifying the provider and region
provider "aws" {
  region = "us-east-1"
}

# VPC- Rearc
resource "aws_vpc" "rearc_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rearc-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "rearc_igw" {
  vpc_id= aws_vpc.rearc_vpc.id

  tags= {
    Name = "rearc-igw"
  }
}

# Subnet A (AZ1)
resource "aws_subnet" "rearc_subnet_a" {
  vpc_id = aws_vpc.rearc_vpc.id
  cidr_block= "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "rearc-subnet-a"
  }
}

# Subnet B (AZ2)
resource "aws_subnet" "rearc_subnet_b" {
  vpc_id = aws_vpc.rearc_vpc.id
  cidr_block= "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "rearc-subnet-b"
  }
}

# Route table
resource "aws_route_table" "rearc_rt" {
  vpc_id = aws_vpc.rearc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rearc_igw.id
  }

  tags = {
    Name = "rearc-rt"
  }
}

# Route table association
resource "aws_route_table_association" "rearc_rta_a" {
  subnet_id = aws_subnet.rearc_subnet_a.id
  route_table_id = aws_route_table.rearc_rt.id
}

resource "aws_route_table_association" "rearc_rta_b" {
  subnet_id = aws_subnet.rearc_subnet_b.id
  route_table_id = aws_route_table.rearc_rt.id
}

# Security Group
resource "aws_security_group" "rearc_sg" {
  name = "rearc-sg"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id = aws_vpc.rearc_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port= 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rearc-sg"
  }
}

# EC2 instance (deploying to Subnet A)
resource "aws_instance" "rearc_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.rearc_subnet_a.id
  vpc_security_group_ids = [aws_security_group.rearc_sg.id]
  associate_public_ip_address = true
  key_name  = "rearc-key"

  tags = {
    Name = "rearc-server"
  }
}

# Application Load Balancer
resource "aws_lb" "rearc_alb" {
  name = "rearc-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.rearc_sg.id]
  subnets = [
    aws_subnet.rearc_subnet_a.id,
    aws_subnet.rearc_subnet_b.id
  ]

  tags = {
    Name = "rearc-alb"
  }
}

# Target Group TG
resource "aws_lb_target_group" "rearc_tg" {
  name = "rearc-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.rearc_vpc.id

  health_check {
    path = "/"
    protocol= "HTTP"
    interval  = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "rearc-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "rearc_listener" {
  load_balancer_arn = aws_lb.rearc_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.rearc_tg.arn
  }
}

# Register EC2 instance
resource "aws_lb_target_group_attachment" "rearc_tg_attachment" {
  target_group_arn = aws_lb_target_group.rearc_tg.arn
  target_id = aws_instance.rearc_server.id
  port  = 80
}


# S3 bucket for TF state backend
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "rearc-tfstate-abcd"

  tags = {
    Name = "rearc-tfstate-abcd"
  }
}

# DynamoDB table to store lock state
resource "aws_dynamodb_table" "terraform_lock" {
  name  = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key  = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock"
  }
}


/*
#===============================OLD CODE ===================================================
# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
resource "aws_vpc" "rearc_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rearc-vpc"
  }
}

# Subnet Configuration
resource "aws_subnet" "rearc_subnet" {
  vpc_id  = aws_vpc.rearc_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "rearc-subnet"
  }
}

# Security Group Configuration
resource "aws_security_group" "rearc_sg" {
  name  = "rearc-sg"
  description = "Allow HTTP and HTTPS"
  vpc_id = aws_vpc.rearc_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rearc-sg"
  }
}

# EC2 Instance for hosting the Node app
resource "aws_instance" "rearc_server" {
  ami = "ami-02457590d33d576c3" # Amazon Linux 2 AMI in us-east-2
  instance_type= "t2.micro"
  subnet_id = aws_subnet.rearc_subnet.id
  vpc_security_group_ids = [aws_security_group.rearc_sg.id]
  associate_public_ip_address= true
  key_name = "rearc-key"

  tags = {
    Name = "rearc-server"
  }
}
#Adding ALB
/*resource "aws_lb" "rearc_alb" {
  name               = "rearc-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rearc_sg.id]
  subnets            = [aws_subnet.rearc_subnet.id]

  tags = {
    Name = "rearc-alb"
  }
}

# S3 bucket for TF backend
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "rearc-tfstate-abc"

  tags = {
    Name = "rearc-tfstate-abc"
  }
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name  = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock"
  }
}

*/