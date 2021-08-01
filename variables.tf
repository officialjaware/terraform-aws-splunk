
# Required configuration

variable "aws_profile" {
    type = string
    default = "" # Ex. default
}

variable "aws_region" {
    type = string
    default = "" # Ex. us-west-2
}

variable "aws_az" {
     type = string
     default = "" # Ex. us-west-2a
}

variable "aws_privatekeypath" {
    type = string
    default = "" # The path to your aws private key ("somekey.pem"). You can also use
}                # the generate-awskeypair.sh script to generate a new one

variable "aws_keyname" {
    type = string
    default = "" # The name of your aws key ("somekey")
}



variable "aws_splunkwebport" {
    type = string
    default = "8000"
}

variable "aws_splunkmgmtport" {
    type = string
    default = "8089"
}

variable "aws_allow_cidr_range" {
    type = string
    default = "0.0.0.0/0"
}

variable "aws_instance_type" {
    type = string
    default = "t2.medium"
}

variable "aws_sshuser" {
    type = string
    default = "centos"
}

variable "aws_ebs_volumesize" {
    type = number
    default = "40"
}

variable "amifilter_osname" {
    type = string
    default = "CentOS 7.9*"
}

variable "amifilter_osarch" {
    type = string
    default = "x86_64"
}

variable "amifilter_osvirtualizationtype" {
    type = string
    default = "hvm"
}

variable "amifilter_owner" {
    type = string
    default = "125523088429" # CentOS 7.9
}