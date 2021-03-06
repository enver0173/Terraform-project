variable "AWS_ACCESS_KEY" {
  default = ""
}

variable "AWS_SECRET_KEY" {
  default = ""
}

variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-01f14919ba412de34"
  }
}
