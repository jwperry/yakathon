provider "aws" {
  access_key = "${trimspace(file("../../secrets/plaintext/aws/dev_access_key"))}"
  secret_key = "${trimspace(file("../../secrets/plaintext/aws/dev_secret_key"))}"
  region     = "us-west-2"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  tags {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-west-2a"
  tags {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id = "${aws_subnet.my_subnet.id}"
  private_ips = ["172.16.10.100"]
  tags {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
    ami = "ami-22b9a343" # us-west-2
    instance_type = "t2.micro"
    network_interface {
     network_interface_id = "${aws_network_interface.foo.id}"
     device_index = 0
  }
  tags {
    Name = "yakathon"
  }
}
