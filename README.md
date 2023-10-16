# Kali EC2 Terraform
For when you need an EC2 instance running Kali Linux. Intended for training or pentest purposes.

# Prerequisites
## Accept Kali Linux Marketplace Agreement
This module uses the official Kali Linux AMI. The marketplace agreement needs to be accepted before an instance can be created by Terraform. This needs to be one once per AWS account. ([Or perhaps once per AWS organization if set-up correctly](https://docs.aws.amazon.com/marketplace/latest/buyerguide/organizations-sharing.html).) Marketplace Link: https://aws.amazon.com/marketplace/pp/prodview-fznsw3f7mq7to

# Usage
*Special Note: All of these usage instructions were specifically created on/for a Linux machine. Some variation may be needed for MacOS or Windows hosts.*  

## If you plan on connecting with SSM
This works great if you only need command-line access to the instance.
```hcl
module "kali-ec2" {
  source             = "git::https://github.com/Ngibb/terraform-kali-linux-ec2.git"
}

output "ssm_start_session_command" {
  value = module.kali-ec2.ssm_start_session_command
}
```
## Connecting with SSM
*You will need to install the [Session Manager plugin for the AWSCLI](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html).*

```bash
$(terraform output -raw ssm_start_session_command)
```

## If you plan on connecting with SSH through SSM
This is especially useful if you need to access a tool with a graphical interface (e.g. wireshark or rdesktop) through X11 forwarding. The `ssh_command` output includes the `-X` flag for X11 forwarding. This command will use SSH through SSM, so port 22 doesn't even need to be open to the internet. Neat!

In order for this to work, you need to make an addition/modification to your ssh client config. The addition looks like this on Linux:
```
# SSH over Session Manager
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```
The AWS documentation for SSH through SSM can be found [here](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html). It gives full details for the config changes needed for SSH over SSM.

```hcl
module "kali-ec2" {
  source             = "git::https://github.com/Ngibb/terraform-kali-linux-ec2.git"
  priv_key_directory = "/home/ngibb/.ssh" # Writes out your private key for the instance.
}

output "ssm_start_session_command" {
  value = module.kali-ec2.ssm_start_session_command
}

output "ssh_command" {
  value = module.kali-ec2.ssh_command
}
```
## Connecting with SSM
```bash
$(terraform output -raw ssh_command)
```

# Networking
This module automatically creates a VPC with a public subnet, and places the instances inside the public subnet, assigning it a public IP address. All egress traffic is allowed from the instance. The built-in security group for the Kali instance does not allow ingress traffic.

You can provide your own `vpc_id`, `subnet_id`, and `security_group_ids` to stop the module from creating networking resources and customize the deployment (e.g. deploy in an existing VPC and subnet.). `vpc_id`, `subnet_id`, and `security_group_ids` must all be defined together, or not at all.

# Instance Settings
## Instance Type
You can replace the default instance type (t2.nano to save money) with the instance type of your choice, as long as it is compatible with the underlying AMI. 

## User Data
You can used `user_data_filepath` to overwrite user data in the module. The module userdata installs the SSM agent. 

## Instance Profile
The instance profile is the minimum required to allow SSM access to function. You can replace it with the `iam_instance_profile_name` variable.

## EBS Volume
Encrypted by default. You can change the default volume size from 12 to [gibibytes](https://simple.wikipedia.org/wiki/Gibibyte) using the `ebs_vol_size_gb` variable.

# Tagging
The `additional_tags` variable is available to add additional tags like to all applicable resources.


# Contributing
Please do. Help out by opening an Issue or PR. 

