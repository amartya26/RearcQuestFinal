variable "ami_id" {
  description = "AMI ID for the EC2 "
  type = string
  default = "ami-09e6f87a47903347c"
}

variable "instance_type" {
  description = "type of EC2 instance"
  type = string
  default = "t2.micro"
}