#provider "aws" or "azure" or "Kubernetes"
#           you can have multiple providers on one terraform file
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYXXYWEWIRZPDLVHL"
  secret_key = "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"
}

#Declare a Variable
variable "subnet_prefix" {
  description = "cidr block prefix for the subnet"
  type        = String
}

#resource "provider_resource type" "name"
#          provider i.e aws
#          resource type i.e instance
#          name i.e name that is unique only in terraforms, aws will not be aware of this name
#          ami = Amazon Machine Image - just an image
resource "aws_instance" "ceds-server" {
  ami               = "ami-04505e74c0741db8d"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"

  #tags   - this will name the resource in AWS
  tags = {
    "Name" = "ubuntu"
  }
}

#Create a VPC (Virtual Private Cloud
resource "aws_vpc" "ceds-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "ceds-vpc"
  }
}

#Create an Internet Gateway
resource "aws_internet_gateway" "ceds-internet-gateway" {
  vpc_id = aws_vpc.ceds-vpc.id

  tags = {
    Name = "ceds-internet-gateway"
  }
}

#Create a route table
resource "aws_route_table" "ceds-route-table" {
  vpc_id = aws_vpc.ceds-vpc.id

  # To setup a default route meaning all traffic to the Internet 
  # route we set the cidr_block to 0.0.0.0/0
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ceds-internet-gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.ceds-internet-gateway.id
  }

  tags = {
    Name = "ceds-route-table"
  }
}

#Create a Subnet
#Reference the VPC resource above
resource "aws_subnet" "ceds-subnet" {
  vpc_id            = aws_vpc.ceds-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ceds-subnet"
  }
}

#Create Route table association
#This will associate the Subnet to the route table
resource "aws_route_table_association" "ceds-route-table-association" {
  subnet_id      = aws_subnet.ceds-subnet.id
  route_table_id = aws_route_table.ceds-route-table.id
}

#Create a security group
#It's good to create a policy that will allow the protocols that you need

resource "aws_security_group" "ced-allow-web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ced-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 447
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 2
    to_port          = 2
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # -1 any Protocol 
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ceds-allow-web"
  }
}

#Create a network interface

resource "aws_network_interface" "ceds-nic" {
  subnet_id       = aws_subnet.ceds-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.ced-allow-web.id]
}

#Create an elastic IP
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.ceds-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = aws_internet_gateway.ceds-internet-gateway
}


