#provider "aws" or "azure" or "Kubernetes"
#           you can have multiple providers on one terraform file
provider "aws" {
  region     = "us-east"
  access_key = "AKIAYXXYWEWIRZPDLVHL"
  secret_key = "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"
}

#resource "provider_resource type" "name"
#          provider i.e aws
#          resource type i.e instance
#          name i.e name that is unique only in terraforms, aws will not be aware of this name
#          ami = Amazon Machine Image - just an image
resource "aws_instance" "my-first-server" {
  ami           = "ami-09879879879werce1"
  instance_type = "t2.micro"

  #tags   - this will name the resource in AWS
  tags = {
    "Name" = "ubuntu"
  }
}

#Create a VPC (Virtual Private Cloud)
resource "aws_vpc" "my-first-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "production"
  }
}

#Create a Subnet
#Reference the VPC resource above
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.my-first-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}
