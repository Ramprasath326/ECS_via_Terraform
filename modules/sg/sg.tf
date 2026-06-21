resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow 80/443 inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "web_sg"
  }
}
#Allow inbound HTTP traffic
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
#Allow inbound HTTPS traffic
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}


#Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}


#creating api SG

resource "aws_security_group" "api_sg" {
  name        = "api_sg"
  description = "Allow 8080 inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "api_sg"
  }
}

#Allow inbound traffic on api SG
resource "aws_vpc_security_group_ingress_rule" "allow_from_web_sg" {
  security_group_id = aws_security_group.api_sg.id
  referenced_security_group_id = aws_security_group.web_sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
