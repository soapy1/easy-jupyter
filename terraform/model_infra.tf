provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAINWJ4QBTDWL6CMMA"
  secret_key = "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"
}

resource "aws_instance" "web" {
  # US-east-1 Ubuntu 16.04 LTS hvm:ebs-ss ami-927185ef
  ami           = "ami-58e34e25"
  instance_type = "c5.xlarge"
  key_name = "dev"
  subnet_id = "subnet-c11c1fa5"
  security_groups = ["sg-ea6bbe9c"]
  associate_public_ip_address = true
}



# Output information about the sever
output "ip" {
  value = "${aws_instance.web.public_ip}"
}

output "id" {
  value = "${aws_instance.web.id}"
}
