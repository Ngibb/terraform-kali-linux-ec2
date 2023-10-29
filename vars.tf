variable "priv_key_directory" {
  default     = null
  type        = string
  description = <<-EOT
  This is the location on disk where the private key for your Kali EC2
  instance will be written. You might want to choose something like 
  "/home/<username>/.ssh/kali_priv_key". Ommiting this value will stop Terraform from writing the file. 
EOT
}

variable "vpc_id" {
  default     = null
  description = "Used to deploy the instance within your own existing netowrking resources, instead of those created by the module. vpc_id, subnet_id, and security_group_ids must all be defined together, or not at all."
  type        = string
}

variable "subnet_id" {
  default     = null
  description = "Used to deploy the instance within your own existing netowrking resources, instead of those created by the module. vpc_id, subnet_id, and security_group_ids must all be defined together, or not at all."
  type        = string
}

variable "security_group_ids" {
  default     = null
  description = "Used to deploy the instance within your own existing netowrking resources, instead of those created by the module. vpc_id, subnet_id, and security_group_ids must all be defined together, or not at all."
  type        = list(string)
}

variable "instance_type" {
  default     = "t2.nano"
  description = "The type of EC2 instance to create."
  type        = string
}

variable "associate_public_ip" {
  default = true
  type    = bool
}

variable "user_data_filepath" {
  default = null
  type    = string
}

variable "iam_instance_profile_name" {
  default = null
  type    = string
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags."
  type        = map(string)
}

variable "ebs_vol_size_gb" {
  default     = 12
  description = "The size of the EBS volume that will be attached to the instance, in gibibytes."
  type        = number
}

variable "enable_rdp" {
  default = true
}

variable "kali_rdp_port" {
  default = 3389
  type    = number
}

variable "local_rdp_port" {
  default = 55678
  type    = number
}