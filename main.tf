provider "aws" {
     region = "eu-central-1"
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable instance_type {}
variable my_ip {}
variable public_key_location {}
variable db_password {}


resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "prod-vpc"
    }
}

resource "aws_route_table" "myapp-route-table"{
    vpc_id = aws_vpc.myapp-vpc.id

    route { 
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp_igw.id
    }
    tags = {
        Name: "prod-rtb"
    }
}

resource "aws_internet_gateway" "myapp_igw"{
    vpc_id = aws_vpc.myapp-vpc.id
        tags = {
        Name: "prod-igw"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = "prod-subnet-1"
    }
}

resource "aws_route_table_association" "a-rtb-subnet"{
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg"{
    name = "prod-app-sg"
    vpc_id = aws_vpc.myapp-vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
        ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
        tags = {
        Name: "prod-app-sg"
    }
}

resource "aws_security_group" "rds-sg"{
    name = "prod-rds-sg"
    vpc_id = aws_vpc.myapp-vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
        ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.myapp-sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
        tags = {
        Name: "prod-rds-sg"
    }
}


data "aws_ami" "latest-amazon-linux-image"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
    }
}

resource "aws_key_pair" "ssh-key"{
    key_name = "server-key"
    public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server"{
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address  = true 
    key_name = aws_key_pair.ssh-key.key_name
    tags = {
        Name = "prod-server"
    }
    
}

output "aws_ami_id"{
    value = data.aws_ami.latest-amazon-linux-image.id
}


resource "aws_db_instance" "myapp-rds" {
  allocated_storage    = 20
  db_name              = "prod-rds"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  availability_zone = var.avail_zone
}