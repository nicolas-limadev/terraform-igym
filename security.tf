resource "aws_security_group" "allow_tls_igym" {
  name        = "allow_tls_igym"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_gym.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC test"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port from API back-end"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port from front-end"
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Gateway internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "allow_tls"
    Owner = "iGym"
  }
}

resource "aws_security_group" "database_ssh_igym" {
  name        = "database_ssh_igym"
  description = "SSH e Postgres inbound traffic"
  vpc_id      = aws_vpc.vpc_gym.id

  ingress {
    description = "SSH from database in subnet public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_tls.id]
  }

  ingress {
    description     = "Allow access from allow_tls"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_tls.id]
  }

  ingress {
    description = "port PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_tls.id]
  }

  egress {
    description      = "Gateway NAT communication"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "database_ssh"
    Owner = "iGym"
  }
}