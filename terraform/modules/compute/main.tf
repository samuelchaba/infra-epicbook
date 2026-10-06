data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-ec2-key"
  public_key = file(pathexpand(var.ssh_public_key_path))

  tags = {
    Name = "${var.project_name}-ec2-key"
  }
}

resource "aws_instance" "frontend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.frontend_sg_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-frontend"
    Tier = "frontend"
  }
}

resource "aws_instance" "backend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.backend_subnet_id
  vpc_security_group_ids      = [var.backend_sg_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-backend"
    Tier = "backend"
  }
}
