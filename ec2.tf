resource "aws_instance" "inst_1" {
  ami                         = "ami-0d53d72369335a9d6"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pub_sub.id
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "terraform-ec2"
  }
}
