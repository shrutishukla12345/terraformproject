variable "ec2_instance_type"{
    default = "t2.micro"
    type = string
}
variable "ec2_ami"{
    default = "ami-0c55b159cbfafe1f0"
    type=string
}
variable "ec2_deafult_root_storage"{
    default = 10
    type = number
}
variable "env"{
    default="PROD"
    type=string
}
