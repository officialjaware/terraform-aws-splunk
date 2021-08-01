

provider "aws" {
 profile = var.aws_profile
 region = var.aws_region
}

resource "aws_security_group" "splunk" {
  name = "splunk-sg"
  egress = [
    {
      cidr_blocks      = [ var.aws_allow_cidr_range, ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ var.aws_allow_cidr_range, ]
     description      = "ssh rule"
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  },
  {
     cidr_blocks      = [ var.aws_allow_cidr_range, ]
     description      = "splunk web"
     from_port        = var.aws_splunkwebport
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = var.aws_splunkwebport
  }
  ]
}


resource "aws_instance" "splunk" {
#  ami           = "ami-00f8e2c955f7ffa9b"     #CentOS AMI
  ami = data.aws_ami.ami_os_filter.id
  instance_type = var.aws_instance_type
  availability_zone = var.aws_az
  key_name = var.aws_keyname

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.aws_ebs_volumesize
  }

  tags = {
    Name = "splunk"
  }
  vpc_security_group_ids = [aws_security_group.splunk.id]


# Copy Splunk install script
  provisioner "file" {

    connection {
      type = "ssh"
      timeout = "120s"
      user = var.aws_sshuser
      host = aws_instance.splunk.public_ip
      private_key = file(var.aws_privatekeypath)
    }
    
    source = "./splunk-resources"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    connection {
      host = aws_instance.splunk.public_ip
      type = "ssh"
      user = var.aws_sshuser
      timeout = "120s"
      private_key = file(var.aws_privatekeypath)
    }
    inline = [
      "sudo chmod +x /tmp/splunk-resources/install.sh",
      "sudo /tmp/splunk-resources/install.sh",
      "echo Splunk is installed!"
    ]
  }

}

#AMI Filter for Linux CentOS 7

data "aws_ami" "ami_os_filter" {
     most_recent = true

     filter {
        name   = "name"
        values = [var.amifilter_osname]
     }
     filter {
        name = "architecture"
        values = [var.amifilter_osarch]

 }

     filter {
       name   = "virtualization-type"
       values = [var.amifilter_osvirtualizationtype]

 }

     owners = [var.amifilter_owner] # Canonical

 }



output "external_ip" {
  value = aws_instance.splunk.public_ip
}
