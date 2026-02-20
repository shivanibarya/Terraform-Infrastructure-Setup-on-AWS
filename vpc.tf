resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/21"
  tags = {
    Name = "vpc-1"
  }
}
 
resource "aws_subnet" "pub_sub" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/22"
  availability_zone = "us-west-1a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "pri_sub" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/23"
  availability_zone = "us-west-1c"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table" "my_pubrt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "public-rt"
  }
}
 
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.my_pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}
 
resource "aws_route_table_association" "my_pubrta" {
  route_table_id = aws_route_table.my_pubrt.id
  subnet_id      = aws_subnet.pub_sub.id
}

resource "aws_route_table_association" "my_prta" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id      = aws_subnet.pri_sub.id
}
 
resource "aws_security_group" "my_sg" {
  name        = "my_sg_1"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
