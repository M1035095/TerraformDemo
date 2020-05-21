variable "key_name" {
  default = "mykey-test-1"
}

variable "pvt_key" {
  default = "/root/.ssh/amit-personal-aws.pem"
}

variable "ap-south-1" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "sg-id" {
  default = "sg-0c279b0ea5c8a9b0f"
}
