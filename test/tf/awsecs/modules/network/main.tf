resource "aws_vpc" "main" {
  cidr_block = "${var.address_space}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "internal_a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.subnet_cidr_a}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.main"]
}

resource "aws_subnet" "internal_b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.subnet_cidr_b}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.main"]
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.internal_a.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.internal_b.id}"
  route_table_id = "${aws_route_table.r.id}"
}
