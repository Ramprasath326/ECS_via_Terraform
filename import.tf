#resource "aws_instance" "Unix-vm-imported" {
#  instance_type = "t3.micro"
#  ami           = "ami-0b6d9d3d33ba97d99"
#}


import{
    to = aws_instance.Unix-vm-imported
    id = "i-041d3e8e5d302f2ff"

}