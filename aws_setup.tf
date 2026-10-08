resource "aws_instance" "myec2"{
    count=1 #it will create 1 instance
    ami = var.ec2_ami
    instance_type = var.ec2_instance_type
    vpc_security_group_ids=["${aws_security_group.security_group.id}"]
    key_name="${aws_key_pair.mynewkey.key_name}"
    user_data=file("nginx_install.sh")
    depends_on=[aws_security_group.security_group,aws_key_pair.mynewkey] #meta-argument to specify dependencies between resources
    root_block_device{
        #conditonal expression to set the volume size based on the environment variable
        volume_size= var.env=="PROD ?20:var.ec2_default_root_storage" #ternary operator to check the environment and set the volume size accordingly  
}
}
resource "aws_security_group" "security_group"{
    name="security_group"
    description="allow SSH and HTTP inbound traffic"
    dynamic ingress {
    for_each=[22,80]
    iterator=port
    content{
        from_port=port.value
        to_port=port.value
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
  }
  egress{
    description="allow all outbound traffic"
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mynewkey"{
   key_name="mynewkey"
    public_key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0g6k7r8y4J9Q2X+"
}
