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
}
