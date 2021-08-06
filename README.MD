# Terraform template for Splunk Enterprise on AWS
This template provisions base AWS infrastructure and deploys Splunk Enterprise (single instance). This is useful for temporary deployments used for demo/testing purposes.

### Pre-requisites
1. [Install & configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. Configure AWS Account & Terraform as described in sections 1 & 2 [here](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180)
4. Set requred and optional parameters (described below)
5. Paste license in splunk-resources/license.lic

### Terraform Configurable Parameters (variables.tf)

Parameter | Description | Required?
-- | -- | --
aws_profile | The primary named profile to use | Yes
aws_region | AWS Region for cloud resources | Yes
aws_az | AWS Availability Zone for cloud resources | Yes
aws_privatekeypath | The path to the AWS private key ("somekey.pem") on your local system | Yes
aws_keyname | The name of your key ("somekey") | Yes
aws_splunkwebport | Port for Splunk Web. Defaults to 8000 | No
aws_splunkmgmtport | Splunk Management port. Defaults to 8089 | No
aws_allow_cidr_range | CIDR block for outgoing traffic. Defaults to all | No
aws_instance_type | EC2 instance type. Defaults to t2.medium | No
aws_sshuser | SSH user of the AMI. Defaults to "centos" for the CentOS 7.x AMI | No
aws_ebs_volumesize | Size of the EBS volume attached to EC2 instance. *(Splunk will complain about disks smaller than 20GB)* Defaults to 40GB | No
amifilter_osname | AMI OS name to search for. Defaults to "CentOS 7.9*" | No
amifilter_osarch | OS architecture of the AMI to search for. Defaults to "x86_64" | No
amifilter_osvirtualizationtype | OS Virtualization Type when searching for AMI. Defaults to "hvm" | No
amifilter_owner | Sets owner filter when searching for AMI. Defaults to "125523088429" for CentOS 7.9* | No

### Splunk Installation Configurable Parameters (installsplunkasrootuser.sh or user-seed.conf)

Parameter | Description | Required?
--- | --- | ---
splunkuserpassword | Splunk admin password (No single quotes). Defaults to "Splunk.5". *(follow directions in install script)* | Yes
hostname | Hostname for the Splunk instance. Defaults to "Splunk" | Yes


### Usage

1. Initialize Terraform and download plugins by running `terraform init`
2. Deploy with `terraform plan` and `terraform apply`

### Accessing Splunk Web
Terraform will output the external IP address of the EC2 instance. Copy & paste this URL into your web browser with ":XXXX" (no quotes) as a suffix, where XXXX is the Splunk Web port number set in the variables file (defaults to 8000). Ex. 10.10.10.10:8000

### Cleanup
To destroy the resources created by Terraform, run `terraform destroy`

This deployment template is provided for demo/POC purposes only.

### To do
* consolidate both Terraform & Splunk variables into one file
