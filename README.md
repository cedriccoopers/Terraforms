# This is my First Terraform Tutorial that creates AWS Resources

- Added a new AWS Provider
- Added a new Instance
- Added a new VPC, Subnet
- Subnet references the VPC
- Associate subnet with Route Table
- Create Security Group to allow port 22, 80, 443
- Create a network interface with an ip in the subnet that was created in step 3
- Assign an elastic IP (Public IP) to the network interface created in step 7
- Create Ubuntu server and install/enable apache
