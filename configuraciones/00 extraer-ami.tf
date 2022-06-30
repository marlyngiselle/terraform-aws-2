data "aws_ami" "os_ubuntu" {
  owners      = ["099720109477"] #canonical -Empresa que hace ubuntu
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}