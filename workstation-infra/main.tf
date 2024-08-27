module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "workstation"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-08ab8575176da550c"]
  subnet_id              = "subnet-0f87134601ecece2c"
  ami                    = "ami-041e2ea9402c46c32"

  user_data = file("workstation.sh")

  tags = {
    Name        = "workstation"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2_instance.id
}

resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 50
  type              = "gp3"
}
